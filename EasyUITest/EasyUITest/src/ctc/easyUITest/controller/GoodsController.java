package ctc.easyUITest.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import com.jfinal.core.Controller;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;


import ctc.easyUITest.model.GoodsModel;
import ctc.easyUITest.model.KindsModel;


public class GoodsController extends Controller{
	public void index(){
		
		//List<GoodsModel> list =  GoodsModel.goodsModel.find("select * from goods where ChildName='哈哈'");
		
		renderJsp("showGoods.jsp");
	}

public void showGoods(){

		List<GoodsModel> list;
		Page<GoodsModel> goodsPage;
		long count;
	
		String pageIndex = getPara("index");
		if(pageIndex==null){
			pageIndex = "1";
		}

		String pageNum = getPara("rows") == null?"0":getPara("rows");  // EasyUI 传参数为： rows表示显示的行数；page表示页码，默认为1
		int pageSize = Integer.parseInt(pageNum);
		int currentPageIndex = Integer.parseInt(pageIndex);
		
		//  判断是否是搜索
		String searchkind = getPara("searchkind")==null?"":getPara("searchkind");
		String searchname = getPara("searchname")==null?"":getPara("searchname");
		if(searchkind.isEmpty() && searchname.isEmpty()){
//			find the data from the currentPag
			goodsPage = GoodsModel.goodsModel.paginate(currentPageIndex,pageSize, "select *", "from goods");
				
//			get the pageCount
			count = Db.queryLong("select count(*) from goods");
//			long pageCount = count%pageSize == 0 ? count/pageSize : count/pageSize+1 // EasyUI 不用自己计算
			
			
		}else{
			// 多条件搜索
			goodsPage = GoodsModel.goodsModel.
					paginate(currentPageIndex, 
							pageSize, 
							"select *", 
							"from goods where kind = ? and name = ? ", 
							searchkind,searchname);
			count = Db.queryLong("select count(*) from goods where kind = ? and name = ?",searchkind,searchname);
		}
		
		list = goodsPage.getList();
		HashMap<String, Object> result = new HashMap<>();
		result.put("rows", list);
		result.put("total", count);
		
		System.out.print(result);
		renderJson(result);
		
	}


//delete goods
public void deleteGoods(){
	String ID = getPara("id");
	boolean results = GoodsModel.goodsModel.deleteById(Integer.parseInt(ID));
	if (results){
		renderJson("success",true);
	}else{
		renderJson("success",false);
	}

}

public void addGoods(){
	String kind = getPara("kind");
	String name = getPara("name");
	String price = getPara("price");
	String num = getPara("num");
	String sumPrice = getPara("sumprice");
	String remark = getPara("remark");
	
	boolean results = new GoodsModel().set("kind", kind).set("name", name).set("price", Float.parseFloat(price))
			.set("num", Integer.parseInt(num)).set("sumprice",Float.parseFloat(sumPrice)).set("remark", remark)
			.save();
	if(results){
		renderJson("success",true);
	}else {
		renderJson("success",false);
	}
}

public void updateGoods(){
	String kind = getPara("kind");
	String name = getPara("name");
	String price = getPara("price");
	String num = getPara("num");
	String sumPrice = getPara("sumprice");
	String remark = getPara("remark");
	String id = getPara("id");
	
//	update sql
	boolean results = GoodsModel.goodsModel.findById(Integer.parseInt(id)).set("kind", kind).set("name", name).set("price", Float.parseFloat(price))
	.set("num", Integer.parseInt(num)).set("sumprice",Float.parseFloat(sumPrice)).set("remark", remark).update();
	if(results){
		renderJson("success",true);
	}else{
		renderJson("success",false);
	}
	}



public void getGoodsKind() throws IOException{
	
	 List<KindsModel> kinds = KindsModel.kindsModel.find("select * from goodskind");
	
	StringBuffer kindStr = new StringBuffer();
	
	for (KindsModel kind : kinds) {
		kindStr.append(kind.getKindsName()).append("*");
	}

	renderText(kindStr.toString());
}

}

