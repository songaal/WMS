package co.fastcat.wms.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)

public @interface DBField {
	
	public enum Type {
		String, Int, Long, Float, Double, Timestamp, Date, DateTime;
	}
	
	public enum ParamType {
		normal, auto, nullparm
	}
	
	String column();
	Type type() default Type.String;
	boolean pk() default false;
	ParamType paramType() default ParamType.normal;
	String expression() default "?";
}
