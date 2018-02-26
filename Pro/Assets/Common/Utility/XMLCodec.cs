using UnityEngine;
using System.Collections;
using System.Xml.Serialization;
using System.IO;
using System;
using System.Reflection;
using System.Collections.Generic;

public class XMLCodec
{
    /// <summary>  
    /// 反序列化XML为类实例  
    /// </summary>  
    /// <typeparam name="T"></typeparam>  
    /// <param name="xmlObj"></param>  
    /// <returns></returns>  
    public static T DeserializeXML<T>(string xmlObj, Type[] extraTypes = null)
    {
        XmlSerializer serializer = new XmlSerializer(typeof(T), extraTypes);
        using (StringReader reader = new StringReader(xmlObj))
        {
            return (T)serializer.Deserialize(reader);
        }
    }

    /// <summary>  
    /// 序列化类实例为XML  
    /// </summary>  
    /// <typeparam name="T"></typeparam>  
    /// <param name="obj"></param>  
    /// <returns></returns>  
    public static string SerializeXML<T>(T obj, Type[] extraTypes = null)
    {
        using (StringWriter writer = new StringWriter())
        {
            new XmlSerializer(obj.GetType(), extraTypes).Serialize(writer, obj);
            return writer.ToString();
        }
    }

    /// <summary>
    /// 获取基类所有子类
    /// </summary>
    /// <param name="baseType"></param>
    /// <returns></returns>
    public static Type[] GetExtraTypes(Type baseType)
    {
        List<Type> extraTypes = new List<Type>();
        Assembly assem = Assembly.GetAssembly(baseType);
        var childList = assem.GetTypes();
        foreach (Type tChild in childList)
        {
            if (IsSubClassOf(tChild, baseType))
            {
                extraTypes.Add(tChild);
            }
        }

        return extraTypes.ToArray();
    }

    /// <summary>
    /// 是否是基类的子类
    /// </summary>
    /// <param name="type"></param>
    /// <param name="baseType"></param>
    /// <returns></returns>
    public static bool IsSubClassOf(Type type, Type baseType)
    {
        var b = type.BaseType;
        while (b != null)
        {
            if (b.Equals(baseType))
            {
                return true;
            }
            b = b.BaseType;
        }
        return false;
    }
}
