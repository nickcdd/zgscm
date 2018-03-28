package com.cqzg168.scm.hibernate;

/**
 * Created by jackytsu on 2017/4/5.
 */
public final class IntegerValuedEnumReflect {
    /**
     * Don't let anyone instantiate this class.
     *
     * @throws UnsupportedOperationException Always.
     */
    private IntegerValuedEnumReflect() {
        throw new UnsupportedOperationException("This class must not be instanciated.");
    }

    /**
     * All Enum constants (instances) declared in the specified class.
     *
     * @param enumClass Class to reflect
     * @return Array of all declared EnumConstants (instances).
     */
    private static <T extends Enum> T[] getValues(Class<T> enumClass) {
        return enumClass.getEnumConstants();
    }

    /**
     * All possible string values of the string valued enum.
     *
     * @param enumClass Class to reflect.
     * @return Available integer values.
     */
    public static <T extends Enum & IntegerValuedEnum> int[] getStringValues(Class<T> enumClass) {
        T[]   values = getValues(enumClass);
        int[] result = new int[values.length];
        for (int i = 0; i < values.length; i++) {
            result[i] = values[i].getCode();
        }
        return result;
    }

    /**
     * Name of the enum instance which hold the respecified string value. If
     * value has duplicate enum instances than returns the first occurrence.
     *
     * @param enumClass Class to inspect.
     * @param value     The int value.
     * @return name of the enum instance.
     */
    public static <T extends Enum & IntegerValuedEnum> String getNameFromValue(Class<T> enumClass, int value) {
        T[] values = getValues(enumClass);
        for (int i = 0; i < values.length; i++) {
            if (values[i].getCode() == value) {
                return values[i].name();
            }
        }
        return "";
    }
}
