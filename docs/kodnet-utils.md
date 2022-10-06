# KodnetUtils object (kodnet.Utils)

#### <img src="https://client-tools.west-wind.com/docs/bmp/classmethod.png" width="20" height="20" /> Method **Dictionary**

```foxpro
FUNCTION Dictionary() as System.Collections.Generic.Dictionary<System.String, System.Object>
```

or 

```foxpro
FUNCTION Dictionary(TKey as System.Type, TValue as System.Type) as System.Collections.Generic.Dictionary<TKey, TValue>
```

or 

```foxpro
FUNCTION Dictionary(TKeyStr as string, TValueStr as string) as System.Collections.Generic.Dictionary<TKey, TValue>
```


Returns a representation (InstanceWrapper) of System.Collections.Generic.Dictionary<TKey, TValue>. If you omit parameters, ```TKey``` is taken as **System.String** type and ```TValue``` as **System.Object** type. 

Consider this example: 

```foxpro
kodnetCOM = _screen.kodnetLoader.v6.COM
kodnetUtils = _screen.kodnetLoader.v6.Utils

dict = m.kodnetUtils.dictionary()
m.dict.item["Name"] = "James"
m.dict.item["Age"] = "28"

* is equivalent to this:
dict = m.kodnetCOM.getStaticWrapper("System.Collections.Generic.Dictionary<System.String, System.Object>").contruct()
m.dict.item["Name"] = "James"
m.dict.item["Age"] = "28"


dict = m.kodnetUtils.dictionary("System.Int32", "System.String")
m.dict.item[0] = "James"
m.dict.item[1] = "28"

* is equivalent to this:
dict = m.kodnetCOM.getStaticWrapper("System.Collections.Generic.Dictionary<System.Int32, System.String>").contruct()
m.dict.item[0] = "James"
m.dict.item[1] = "28"
```

---


#### <img src="https://client-tools.west-wind.com/docs/bmp/classmethod.png" width="20" height="20" /> Method **CustomList**

```foxpro
FUNCTION CustomList(TValue as System.Type, p1 as TValue, p2 as TValue, p3 as TValue ...) as System.Collections.Generic.List<TValue>
```

or 

```foxpro
FUNCTION CustomList(TValueStr as string, p1 as TValue, p2 as TValue, p3 as TValue ...) as System.Collections.Generic.List<TValue>
```

Returns a representation (InstanceWrapper) of System.Collections.List<TValue>. You can pass ```TValue``` as System.Type or as string. 
Is usefull for returns a *List* with values in one line:



```foxpro
kodnetCOM = _screen.kodnetLoader.v6.COM
kodnetUtils = _screen.kodnetLoader.v6.Utils

vocals = m.kodnetUtils.CustomList("System.String", "A", "E", "I", "O", "U")
for i=0 to m.vocals.length - 1
    ?m.vocals.item[m.i]
endfor 

* is equivalent to this:
vocals = m.kodnetCOM.getStaticWrapper("System.Collections.Generic.List<System.String>").contruct()
vocals.Add("A")
vocals.Add("E")
vocals.Add("I")
vocals.Add("O")
vocals.Add("U")
for i=0 to m.vocals.length - 1
    ?m.vocals.item[m.i]
endfor 
```

--- 

#### <img src="https://client-tools.west-wind.com/docs/bmp/classmethod.png" width="20" height="20" /> Method **List**

```foxpro
FUNCTION List(p1 as System.Object, p2 as System.Object, p3 as System.Object ...) as System.Collections.Generic.List<TValue>
```

Similar to **CustomList** but ```TValue``` parameter omitted, and taken as **System.Object**. If no parameters sent, returns an empty **List**



```foxpro
kodnetCOM = _screen.kodnetLoader.v6.COM
kodnetUtils = _screen.kodnetLoader.v6.Utils

list = m.kodnetUtils.List(1, "A", 2, "B")
for i=0 to m.list.length - 1
    ?m.list.item[m.i]
endfor 

* is equivalent to this:
list = m.kodnetCOM.getStaticWrapper("System.Collections.Generic.List<System.Object>").contruct()
list.Add(1)
list.Add("A")
list.Add(2)
list.Add("B")
for i=0 to m.vocals.length - 1
    ?m.list.item[m.i]
endfor 
```

---


#### <img src="https://client-tools.west-wind.com/docs/bmp/classmethod.png" width="20" height="20" /> Method **Array**

```foxpro
FUNCTION Array(TValue as System.Type, p1 as TValue, p2 as TValue, p3 as TValue ...) as TValue[]
```

OR

```foxpro
FUNCTION Array(TValueStr as string, p1 as TValue, p2 as TValue, p3 as TValue ...) as TValue[]
```

Similar to **CustomList** but instead of **List** returns a .NET Array. For example, suppose you need call a method with receives **string[]** as parameter: 

```c# 
public class Test{
    public string Join(string[] words, string separator){
        return string.Join(separator, words);
    }
}
```


```foxpro
kodnetCOM = _screen.kodnetLoader.v6.COM
kodnetUtils = _screen.kodnetLoader.v6.Utils

testClass = m.kodnetCOM.getStaticWrapper("Test")

* create array in oneline
array = m.kodnetUtils.Array("System.String", "kodnet", "is" "great")
?m.testClass.Join(m.array, " ")


* is equivalent to this:
array = m.kodnetCOM.getStaticWrapper("System.String[]").contruct(3)
array.Set(0, "kodnet")
array.Set(1, "is")
array.Set(2, "great")
?m.testClass.Join(m.array, " ")
```

---



#### <img src="https://client-tools.west-wind.com/docs/bmp/classmethod.png" width="20" height="20" /> Method **RGBToArgb**

```foxpro
FUNCTION RGBToArgb(rgb as int, alpha as int) as int
```

Add alpha channel to RGB color and returns the *number* representation. Is usefull for use with **.NET Controls** inside VFP. 

---

#### <img src="https://client-tools.west-wind.com/docs/bmp/classmethod.png" width="20" height="20" /> Method **Await**

```foxpro
FUNCTION Await(task as System.Threading.Task) as System.Object
```

**kodnet** supports async operations. **Await** method allows execute *wait* in sync mode the result of async operation. If the async operations completes *Faulted* (with an error) throws an exception, if not, returns the **result** of async operation.
