package ctc.easyUITest.model;

import com.jfinal.plugin.activerecord.Model;

public class KindsModel extends Model<KindsModel>{
	public final static KindsModel kindsModel = new KindsModel();

	public String getKindsName(){
		return this.getStr("kind");
	}
}
