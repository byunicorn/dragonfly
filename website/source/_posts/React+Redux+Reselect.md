---
title: 使用Reselect配合Redux提升页面性能
date: 2017-03-31 19:19:09
tags: [zmzhang, React, Redux, Reselect]
---


## 使用Reselect 配合Redux提升页面性能

redux是由flux演变而来的javascript状态容器， 提供全局的可预测的状态管理。

#### 优点：

redux和react配合使用有很多好处，比如：

* 状态可预测，可预测，可预测（重要的事情说三遍）

* 单一数据源，应用的所有数据可以保存在一个state树

* 数据不可变，方便追踪定位问题

* 强约束，通过action & reducer来修改数据


使用一段时间感觉也有些问题：

<!-- more -->

* store 的数据冗余，比如：store中保存了一个区域和设备构成的树状数据结构store.tree，当选中一个区域的节点的时候需要保存一个选中的节点store.selectedNode, 当需要展示选中节点下的所有设备及其下级区域的设备的时候就会有一个设备的列表store.devices，但事实情况可能是selectedNode和devices只是分别在一个地方使用，而且既然存了selectedNode就已经可以知道下面所有的device节点了，没有必要都存一份;

* 上述的问题还会导致另外一个问题那就是数据更新复杂以及dom的重复渲染: 因为redux每次reducer修改数据都是返回一个新的state对象，因此当更新store.tree中一个区域下设备的状态从关变成开之后，返回的就是一个新的tree，但是此时store.selectedNode 以及 store.devices中数据的开关状态还没有变，因为他们引用不是同一个对象，所以要更新store.selectedNode 以及 store.devices使其指向新的tree上的节点，可以在mapStateToProps时候计算页面上由state衍生出来的数据

* 前面两个问题可以通过只记录选中节点的id来避免，但是会带来新的问题，重复计算和重新render： 此时store.selectedNode只记录了选中的区域节点的id， 通过connnet的时候在mapStateToProps中计算遍历tree来找到selectedNode节点并同时声称devices的list传入component， 每次store中的数据（tree，selectedNode)发生变化都会重新进行一次计算，可能触发component重新render；

### reselect

Reselect 库可以创建可记忆的(Memoized)、可组合的 selector 函数。可以用来提高 Redux store 里的衍生数据的做cache。上述问题中当state树比较大或计算量大的时候会带来性能问题。

使用方法示例：
我们创建一个可以cache的selector来获取selectedNode下的所有下级区域

``` javascript

const getSelectedArea = (state) => state.selectedArea;

export const getRecursionAreas = createSelector(
  [ getSelectedArea ],
  (selectedArea) =>{
      const recursionAreas = [];
      selectedArea && _.preorderTraverse(selectedArea, (area)=>{ recursionAreas.push(area) },[AppConst.NODE_TYPE.AREA]);
      return recursionAreas;
  }
);

```

其中createSelector接收两个参数： input-selectors 数组和转换函数。input-selectors是get方法获取store中的数据，并将结果作为参数传递给转换函数，如果input-selectors的结果没有发生变化，那么会直接返回上一次的计算结果而不会进入转换函数进行计算。

然后可以mapStateToProps() 以函数的形式调用getRecursionAreas


``` javascript

const mapStateToProps = (state) => {
    return {
        recursionAreas: getRecursionAreas(state),
    };
};

```

这样当重复选中一个node的时候因为selectedNode数据没有变，selector会直接返回上一次的计算结果，从而减少计算量，并且因为props没有变，react也不会重性render dom；

selector还可以进行组合，前一个selector可以作为下一个selector的 input-selectors：

``` javascript

export const getIsAllDevicesSelected = createSelector(
  [ getSelectedDevices, getRecursionAreas],
  (selectedDevices, recursionAreas) => {
      const devicesSize = recursionAreas.reduce((acc, val) => { return acc+val.devices.length}, 0);
      return devicesSize !== 0 && devicesSize === selectedDevices.length;
  }
);


```

使用的时候有两个要注意的地方：

1 . 通常一个component会对应一个selector文件，但是当一个component同时有多个instance的时候（多instance会有redux下如何host状态的问题，之后再说）,或者多个component共用selector的时候，上面的方法就会不work了， 因为所有的instance将会共用一个selector，每个instance的数据不一样所以每次都会导致数据重新计算，为了每次调用getRecursionAreas返回一个selector函数，然后在 mapStateToProps的时候声称一个新的selector，如下：

```javascript

// use for multi instance
export const getRecursionAreasFactory = () =>{
  return createSelector(
      [ getSelectedArea ],
      (selectedArea) =>{
          const recursionAreas = [];
          selectedArea && _.preorderTraverse(selectedArea, (area)=>{ recursionAreas.push(area) },[AppConst.NODE_TYPE.AREA]);
          return recursionAreas;
      }
  )
};

const makeMapStateToProps = () => {
  const getRecursionAreas = getRecursionAreasFactory()
  const mapStateToProps = (state, props) => {
    return {
      recursionAreas: getRecursionAreas(state)
    }
  }
  return mapStateToProps
}
export default connect(
  makeMapStateToProps,
  mapDispatchToProps
)(myComponent)

```

这样每个instance都是自己的selector做cache；

2 . createSelector在做比较input-selectors 的结果是否发生改变的时候用的是 ’===’，所以必须是同一个对象的引用才会返回cache的值，但是实际情况并不总是希望如此，比如要保存一个选中的device的id的列表，可能不是同一个list但是内部的id都是一样的，这种情况我们也希望使用cache。reselect 的api支持自定义equalityCheck方法：

  ``` javascript
  import { createSelectorCreator, defaultMemoize } from 'reselect';
  import shallowEqual from 'shallow-equals';
  const customSelector = createSelectorCreator(defaultMemoize, shallowEqual);
  export const getIsAllDevicesSelected = customSelector(
      [ getSelectedDevices, getRecursionAreas],
      (selectedDevices, recursionAreas) => {
          const devicesSize = recursionAreas.reduce((acc, val) => { return acc+val.devices.length}, 0);
          return devicesSize !== 0 && devicesSize === selectedDevices.length;
      }
  );

  ```

  此时使用的shallowEqual的方式进行比较，当然也可以自己定义比较方式，如deepEqual 。
  reselect代码量很少，但是api支持很多自定义的配置。
