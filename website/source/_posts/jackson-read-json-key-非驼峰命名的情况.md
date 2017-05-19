---
title: jackson read json key 非驼峰命名的情况
date: 2017-05-19 12:53:13
tags:
---
在使用jackson时候遇到身份证刷卡器传过来的json数据的key有大写和小写开头的情况：
```json
{"Address":"xxxx","BirthDay":"19800202","Folk":"汉","IDImage":null,"Id":"310104198002027216","Name":"xx","Sex":"男","bValid":true,"strExpireData":"20350610","image":"base64jpg"}
```
当变量名为ID或者Id时使用jackson 的readvalue无法读成Person.class对象中的数据。可以使用@JsonProperty注释来解决这个问题如:
```java
@JsonProperty("Id")
  private String id;
```
其中`@JsonProperty("Id") `是json字符串中对应的变量名，`id`则是自定义的变量，此时readValue就能够读到Id的值

但是在对Person对象使用writeValue方法的时候会出现同时出现`{ "BValid": true, "bValid": true} ` 的解析错误的情况，所以需要制定只解析字段名，忽略方法，为此还需要在get方法上添加`@JsonIgnore`（如果字段很多就累坏了。。。）

或者在实体类上添加 `@JsonAutoDetect(JsonMethod.FIELD) `（org.codehaus.jackson.annotate.JsonMethod 包）

```java
package com.yitutech.survey.modal;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Created by zmzhang2 on 10/19/16.
 */
public class Person {
  @JsonProperty("Name")
  private String name;
  @JsonProperty("Id")
  private String id;
  @JsonProperty("Address")
  private String address;
  @JsonProperty("BirthDay")
  private String birthday;
  @JsonProperty("Folk")
  private String folk;
  @JsonProperty("IDImage")
  private String idImage;
  @JsonProperty("Sex")
  private String sex;
  @JsonProperty("bValid")
  private Boolean bValid;

  @JsonIgnore
  public String getName(){ return this.name;}
  public void setName(String name){ this.name = name;}

  @JsonIgnore
  public String getId(){ return this.id; }
  public void setId(String id){ this.id = id; }

  @JsonIgnore
  public String getAddress(){ return this.address;}
  public void setAddress(String address){ this.address = address;}

  @JsonIgnore
  public String getBirthday(){ return this.birthday; }
  public void setBirthday(String birthday) { this.birthday = birthday; }

  @JsonIgnore
  public String getFolk(){ return this.folk; }
  public void setFolk(String folk){ this.folk = folk; }

  @JsonIgnore
  public String getIdImage(){ return this.idImage; }
  public void setIdImage(String idImage){ this.idImage = idImage; }

  @JsonIgnore
  public String getSex(){ return this.sex; }
  public void setSex(String sex){ this.sex = sex;}

  @JsonIgnore
  public Boolean getBValid(){ return this.bValid; }
  public void setBValid(Boolean bValid){ this.bValid = bValid; }

  @Override
  public String toString(){
  return "PersonInfo: "+ "name = "+this.name+", id = "+this.id+...";
  }
}
```
```java
package com.yitutech.survey.modal;
import com.fasterxml.jackson.annotation.JsonProperty;
import org.codehaus.jackson.annotate.JsonAutoDetect;
import org.codehaus.jackson.annotate.JsonMethod;

import java.io.Serializable;

/**
 * Created by zmzhang2 on 10/19/16.
 */
@JsonAutoDetect(JsonMethod.FIELD)
public class Person{

  @JsonProperty("Name")
  private String name;
  @JsonProperty("Id")
  private String id;
  
  public String getName(){ return this.name;}
  public void setName(String name){ this.name = name;}

  public String getId(){ return this.id; }
  public void setId(String id){ this.id = id; }
}
```