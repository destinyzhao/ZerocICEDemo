
#include "Common.ice"

module systemmanage {

	//=============================固定值
	struct OrderTable{
		string PutInStorage="PutInStorage";		//待入库
		string BeenPutInStorage="BeenPutInStorage";	//已入库
		string ToBeDispensed="ToBeDispensed";		//待配送
		string ToBeReceivable="ToBeReceivable";		//待收款
		string ToBeConfirmed="ToBeConfirmed";	//待确认
		string Rejected="Rejected";		//被拒收
		string Closed="Closed";		//已关闭
		string PendingPayment="PendingPayment";	//待评论
		string ToBeComments="ToBeComments";	//待付款
		string Inbound="Inbound";	//待收货
		string ToBeShipped="ToBeShipped";//待发货
		string OrderOver="OrderOver";	//已结束
		string 	AllOrder="AllOrder";	//所有订单
		string 	ShopToBeConfirmed="ShopToBeConfirmed";	//店铺待确认
		
	};
	struct OrderStatus{
		int ORDERED=10;		//已下单",1,"您提交了订单，请等待系统确认
		int ONLINEPAY=20;	//在线支付",2,"您完成了付款
		int CANCELED=30;	//取消",3,"订单已取消
		int CONFIRMED=40;	//已确认",4,"卖家已确认
		int DELIVERIES=50;	//配送中",5,"卖家已经发货
		int ARRIVALLOFT=60;	//配送中",6,"货物抵达超爱送仓库
		int DELIVERYTOBUSINESSES=70;	//配送中",7,"货物开始配送
		int CARGODELIVERYBUYERS=80;		//配送完",8,"货物送达买家
		int COMPLETED=90;	// 已完成",8,"买家确认收货
		int CLOSEDORDER=100;	//关闭订单",8,"关闭订单
		//int END=110;	//订单已结束",10,"订单已结束  *********暂不使用
	};
	//订单拒收操作
	struct OrderRejectedOption{
		string Redeliver="Redeliver";//重新发货
		string CloseOrder="CloseOrder";//关闭订单
	};
	struct PayMent{
		string Online="online";//在线支付
		string CashOnDelivery="CashOnDelivery";//货到付款
	};
	struct DeliveryMent{
		string chaoaisong="chaoaisong";//超爱送
	};
	struct ShopStatus{
		int NORMAL=1;//正常
		int AUDITING=2;//待审核
		int FROZEN=3;//冻结
	};
	struct RefundRecordStatus{
		int PendingRefund=1;//待退款
		int RefundIn=2;//退款中
		int Refunded=3;//已退款
	};
	struct ProductCommentType{
		int BAD=1;//差评
		int MIDDLE=2;//中评
		int GOOD=3;//好评"
	};
	
	//============================固定值 end===================================
	
	class BaseSystemConfigIceModule extends ::common::BaseModule{
		string code;
		string description;
		string value;
		string text;
		int dataType;//value数据类型，1整型，2浮点，3字符串，
		int pId;
		int type;//1：系统，2：分类，3：值
		string remark;
	};
	sequence<BaseSystemConfigIceModule> SystemConfigIceModules;
	class SystemConfigIceModule extends BaseSystemConfigIceModule{
		SystemConfigIceModules systemConfigIceModules;
	};
	
	class SystemConfigParam extends ::common::Paramter{
		SystemConfigIceModule systemConfigIceModule;
	};
	class SystemConfigResult extends ::common::PageResult{
		SystemConfigIceModule systemConfigIceModule;
	};
	
	interface SystemManageService{
		//根据代码获取系统配置信息
		SystemConfigResult getSystemConfigByCode(SystemConfigParam systemConfigParam);
		
	};
};