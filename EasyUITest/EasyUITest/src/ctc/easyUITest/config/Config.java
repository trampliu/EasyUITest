package ctc.easyUITest.config;

import com.jfinal.config.Constants;
import com.jfinal.config.Handlers;
import com.jfinal.config.Interceptors;
import com.jfinal.config.JFinalConfig;
import com.jfinal.config.Plugins;
import com.jfinal.config.Routes;
import com.jfinal.kit.PropKit;
import com.jfinal.plugin.activerecord.ActiveRecordPlugin;
import com.jfinal.plugin.activerecord.CaseInsensitiveContainerFactory;
import com.jfinal.plugin.activerecord.dialect.MysqlDialect;
import com.jfinal.plugin.c3p0.C3p0Plugin;
import com.jfinal.render.ViewType;


import ctc.easyUITest.controller.GoodsController;
import ctc.easyUITest.model.GoodsModel;
import ctc.easyUITest.model.KindsModel;

public class Config extends JFinalConfig{

	@Override
	public void configConstant(Constants arg0) {
		// TODO Auto-generated method stub
		PropKit.use("sql.property");
		arg0.setBaseViewPath("WEB-INF/view");
		arg0.setDevMode(true);
		arg0.setViewType(ViewType.JSP);
		arg0.setEncoding("utf-8");
		
	}

	@Override
	public void configHandler(Handlers arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void configInterceptor(Interceptors arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void configPlugin(Plugins arg0) {
		// TODO Auto-generated method stub
		C3p0Plugin cp = new C3p0Plugin(PropKit.get("jdbcUrl"),PropKit.get("user"),PropKit.get("pass"));
        cp.setDriverClass(PropKit.get("driver"));
        arg0.add(cp);

        ActiveRecordPlugin activeRecordPlugin = new ActiveRecordPlugin(cp);
        activeRecordPlugin.setDialect(new MysqlDialect());
        activeRecordPlugin.setShowSql(true); // 打印出sql语句
        activeRecordPlugin.setContainerFactory(new CaseInsensitiveContainerFactory()); // 忽略大小;其实会将key全部转换为大写；那么就要注意，JSP中使用的 datagrid 所对应的key也要改成大写
        arg0.add(activeRecordPlugin);
        activeRecordPlugin.addMapping("GOODS", GoodsModel.class);
        activeRecordPlugin.addMapping("goodskind", KindsModel.class);
		
	}

	@Override
	public void configRoute(Routes arg0) {
		// TODO Auto-generated method stub
		arg0.add("/goods",GoodsController.class,"/");
	}
	

}
