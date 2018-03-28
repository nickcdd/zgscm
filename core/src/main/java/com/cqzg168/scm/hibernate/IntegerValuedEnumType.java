package com.cqzg168.scm.hibernate;

import org.hibernate.HibernateException;
import org.hibernate.engine.spi.SessionImplementor;
import org.hibernate.usertype.EnhancedUserType;
import org.hibernate.usertype.ParameterizedType;

import java.io.Serializable;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Properties;

/**
 * Created by jackytsu on 2017/4/5.
 */
public class IntegerValuedEnumType<T extends Enum & IntegerValuedEnum> implements EnhancedUserType, ParameterizedType {

    /**
     * Enum class for this particular user type.
     */
    private Class<T> enumClass;

    /**
     * Value to use if null.
     */
    private Integer defaultValue;

    public IntegerValuedEnumType() {
    }

    public void setParameterValues(Properties parameters) {
        String enumClassName = parameters.getProperty("enum");
        try {
            enumClass = (Class<T>) Class.forName(enumClassName).asSubclass(Enum.class).asSubclass(IntegerValuedEnum.class);
        } catch (ClassNotFoundException e) {
            throw new HibernateException("Enum class not found", e);
        }

        String defaultValueStr = parameters.getProperty("defaultValue");
        if (defaultValueStr != null && !defaultValueStr.isEmpty()) {
            try {
                setDefaultValue(Integer.parseInt(defaultValueStr));
            } catch (NumberFormatException e) {
                throw new HibernateException("Invalid default value", e);
            }
        }
    }

    public Integer getDefaultValue() {
        return defaultValue;
    }

    public void setDefaultValue(Integer defaultValue) {
        this.defaultValue = defaultValue;
    }

    /**
     * The class returned by <tt>nullSafeGet()</tt>.
     *
     * @return Class
     */
    public Class returnedClass() {
        return enumClass;
    }

    public int[] sqlTypes() {
        return new int[] {Types.TINYINT};
    }

    public boolean isMutable() {
        return false;
    }

    public Object assemble(Serializable cached, Object owner) {
        return cached;
    }

    public Serializable disassemble(Object value) {
        return (Enum) value;
    }

    public Object deepCopy(Object value) {
        return value;
    }

    public boolean equals(Object x, Object y) {
        return x == y;
    }

    public int hashCode(Object x) {
        return x.hashCode();
    }

    /**
     * Retrieve an instance of the mapped class from a JDBC resultset.
     * Implementors should handle possibility of null values.
     *
     * @param rs    a JDBC result set
     * @param names the column names
     * @param owner the containing entity
     * @return Object
     * @throws HibernateException
     * @throws SQLException
     */
    @Override
    public Object nullSafeGet(ResultSet rs, String[] names, SessionImplementor session, Object owner) throws HibernateException, SQLException {
        Integer value = rs.getInt(names[0]);
        if (value == null) {
            value = getDefaultValue();
            if (value == null) { // no default value
                return null;
            }
        }
        String name = IntegerValuedEnumReflect.getNameFromValue(enumClass, value);
        Object res  = rs.wasNull() ? null : Enum.valueOf(enumClass, name);

        return res;
    }

    /**
     * Write an instance of the mapped class to a prepared statement.
     * Implementors should handle possibility of null values. A multi-column
     * type should be written to parameters starting from <tt>index</tt>.
     *
     * @param st    a JDBC prepared statement
     * @param value the object to write
     * @param index statement parameter index
     * @throws HibernateException
     * @throws SQLException
     */
    @Override
    public void nullSafeSet(PreparedStatement st, Object value, int index, SessionImplementor session) throws HibernateException, SQLException {
        if (value == null) {
            st.setNull(index, Types.TINYINT);
        } else {
            st.setInt(index, ((T) value).getCode());
        }
    }

    public Object replace(Object original, Object target, Object owner) {
        return original;
    }

    public String objectToSQLString(Object value) {
        return '\'' + String.valueOf(((T) value).getCode()) + '\'';
    }

    public String toXMLString(Object value) {
        return String.valueOf(((T) value).getCode());
    }

    public Object fromXMLString(String xmlValue) {
        Integer value = Integer.parseInt(xmlValue);
        String  name  = IntegerValuedEnumReflect.getNameFromValue(enumClass, value);
        return Enum.valueOf(enumClass, name);
    }
}
