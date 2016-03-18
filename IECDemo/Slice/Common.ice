
module common{
	class Result{
		long status;
		string message;
	}; 
	
	class PageResult extends Result{
		int totalPages;
		long totalElements;
	};
	
	class Paramter{
		string token;
		string remoteAddress;
		string deviceType;
		string version;
	};
	
	class BasePage{
		int size;
		int page;
	};
	
	struct Date {
		short year;
		short month;
		short day;
		short hour; // 0 - 23
		short minute; // 0 - 59
		short second; // 0 - 59
	};
	
	class BaseModule{
		long id;
		string createdAt;
		string updatedAt;
	};

	//收货地址
	class ReceiverIceModule extends BaseModule{
		long provinceId;
		long cityId; 
		long districtId;
		string provinceName;
		string cityName;
		string districtName;
		string detailedAddress; //详细地址
		string phone;
		string tell;
		int isDefualt;
		string userId;
		string receiverName;//收货人
		string callPhone;//联系电话
		int status;//状态   1：默认，2：其他，3删除
		int sort;
	};
	//========================公共请求参数============================
	class UserParam extends ::common::Paramter{
		 string userId; //userId
	};
	class ShopParam extends ::common::Paramter{
		 long shopId; //shopId
		 BasePage basePage;
	};
	
	//==========================sku 属性
	
		//------------------分类---------------
	class CategoryModule extends ::common::BaseModule{
		long parentId; //查询时使用，
		string name;
		string allParentId;
		int sort; 
		string sku;//sku码
	};
	
	class CategoryParam extends ::common::Paramter{
		CategoryModule categoryModule;
		::common::BasePage basePage;
	};
	
	sequence<CategoryModule> CategoryModules;
	class CategoryListResult extends ::common::Result{
		CategoryModules categoryModules;
	};
	
	//================================店铺分类===============================
	
	class ShopCategoryIceModule extends ::common::CategoryModule{
		::common::CategoryModule categoryModule;
		::common::CategoryModules categoryModules;
	};
	sequence<ShopCategoryIceModule> ShopCategoryIceModules;
	
	class ShopCategoryIceModuleResult extends ::common::Result{
		ShopCategoryIceModules shopCategoryIceModules;
	};
	
	//================================店铺分类 end

	//------------------分类---------------
	
	
	/*
	*商品属性：品牌Module
	*/
	class BrandModule extends BaseModule{
		long cityId;
		string name;
		long factoryId;//工厂id
		string sku;
		string categoryTreeId;
		int categoryId;//查询时候
	};
	
	class BrandParam extends Paramter{
		BrandModule brandModule;
		::common::BasePage basePage;
	};
	
	sequence<BrandModule> BrandModules;
	class BrandListResult  extends Result{
		BrandModules brandModules;
	};
	
	//===============factory===============
	class FactoryIceModule extends ::common::BaseModule{
		string factoryName;//工厂名称
		string sku;//sku
		long province;//省
		long city;//	市
		long areaId;//工厂地区ID
		long shopId;//店铺id
		string factoryAddress;//工厂详细地址
		long sort;//	排序
		string remark;//	v备注
		
	};
	sequence<FactoryIceModule> FactoryIceModules;
	class FactoryIceResult extends ::common::Result{
		FactoryIceModules factoryIceModules;
	};
	
	class FactoryIceParam extends ::common::Paramter{
		FactoryIceModule factoryIceModule;
	};
	
	//=======================sku area
	
	class AreaIceModule extends ::common::BaseModule{
		string name;
		long pId;
	    int isDeleted;//删除
		int sort;//排序
	};
	
	class AreaParam extends ::common::Paramter{
		AreaIceModule areaIceModule;
		::common::BasePage basePage;
	};
	
	sequence<AreaIceModule> AreaIceModules;
	class AreaIceResult extends ::common::Result{
		AreaIceModules areaIceModules;
	};
	
	//=======================sku area end
	//=============商品单位
	class UnitModule extends ::common::BaseModule{
		string name;
		int categoryId;
		int brandId;//查询时候
		string sku;
		string categoryIds;
	};
	
	class UnitParam extends ::common::Paramter{
		UnitModule unitModule;
		::common::BasePage basePage;
	};
	
	sequence<UnitModule> UnitModules;
	class UnitListResult extends ::common::Result{
		UnitModules unitModules;
	};
	/*
	*商品属性：容量Module
	*/ 
	class CapacityModule extends ::common::BaseModule{
		string name;
		string categoryTreeId;
		int categoryId;
		int brandId;//查询时候
		string sku;
		long cityId;
	};
	
	class CapacityParam extends ::common::Paramter{
		CapacityModule capacityModule;
		::common::BasePage basePage;
	};
	
	sequence<CapacityModule> CapacityModules;
	class CapacityListResult extends ::common::Result{
		CapacityModules capacityModules;
	};
	//商品类型
	class TypeModule extends ::common::BaseModule{
		string name;
		string categoryTreeId;
		int categoryId;
		int brandId;//查询时候
		string sku;
		long cityId;
	};
	
	class TypeParam extends ::common::Paramter{
		TypeModule typeModule;
		::common::BasePage basePage;
	};
	
	sequence<TypeModule> TypeModules;
	class TypeListResult extends ::common::Result{
		TypeModules typeModules;
	};
	
	
	//========================加急费模板Module对象====================
	class UrgentFreightTemplateIceModule extends ::common::BaseModule{
		 string templateName; //模板名称
		 string urgentFreightPrice;//加急运费
		 long shopId;//添加模板商超
		 string remark;//备注
		 int sort;//排序号
		 int type;//模板类型[0 时间加急模式  1满数量及时发送]
		 int deliveryDate;//到货时间（天）
	};
	
	//店铺Module
	class ShopIceModule extends ::common::BaseModule{
		 string shopName;//店铺名称
		 string contactPhone;//联系电话
		 string userId;//用户表ID
		 long logoId;//店铺logoId
		 string logoUrl;//logourl
		 long topBackgroundId;//店铺顶部背景id
		 string topBackgroundUrl;//顶部背景url
		 long shopAdId; //店铺广告id
		 string shopAdUrl; //店铺广告url
		 string contactPerson;//联系人
		 string contactTel;//固定电话
		 string shopIntroduce;//店铺介绍
		 string closingAccountDate;//结算时间
		 string orderTime;//最迟下单时间
		 string unifyDeliveryTime;//统一发货时间
		 string businessPic;//营业执照
		 string businessPicUrl;//营业执照url
		 string businessNum;//营业执照注册号
		 string companyName;//公司名称
		 string companyPersonNum;//法人身份证
		 long provinceId;//公司所在地省;
		 long cityId;//公司所在市
		 long districtId;//地区
		 string addressDetails;//详细地区
		 string businessScope;//经营范围主营类目
		 int sort;//排序
		 int isDelete;//删除
		 int score;//积分
		 float income;//收益
		 int status;//1:正常，2：待审核，3：冻结，
		 int contract;//是否已签合同1：是，2：否
		 int isSecurityDeposit;//保证金是否缴纳1：是，2：否
		 int securityDeposit;//保证金
		 int isSettlementDate;//结算日设置1：是，2：否
		 int settlementDate;//结算日
	};
	
	sequence<UrgentFreightTemplateIceModule> UrgentFreightTemplateIceModules;
	//商品Module
	class ProductIceModule extends ::common::BaseModule {
		   string name;//商品名称',
		   string subtitle;//副标题',
		   string productCode;//商品条码',
		   int num;//实际数量
		   int comments;//评论数
		   string description;//商品描述
		   string retailPrice;//零售价格',
		   string wholesalePrice;//批发价格,超爱送价格',
		   string unitPrice;//单价',
		   string pictureIds;//商品图片IDS 数组格式 [ [ 1 , 0 ] , [ 2 ,1 ] ]    文件表ID，1默认封面',
		   string pictureUrls;//商品图片URLS 逗号分开',
		   long defaultPictureId;//商品默认图片ID',
		   string defaultPictureUrl;//商品默认图片URL',
		   long shopId;//店铺ID',
		   string shopName;
		   int sort;//排序',
		   string remark;//备注',
		   int isDelete;//删除 [0 未删除 1已删除]',
		   string serviceIds;//商品支持服务IDS0,1.2',
		   long province;//省',
		   long city;//市',
		   long district;//地区',
		   long productUnit;//商品单位',
		   long productType;//商品类型',
		   long oneCapacity;//单品容量',
		   string oneCapacityName;//单品容量名称',
		   long factoryId;//
		   long brandId;//品牌id',
		   string urgentTemplateIds;//运费模版ids
		   UrgentFreightTemplateIceModules urgentFreightTemplateIceModules;
		   long defaultUrgentTemplateId;//默认模版
		   string productCategoryIds;//商品分类ids',
		   long productCategoryId;//商品分类id',
		   int status;//状态，0下架，1上架,2审核',
		   int sales;//销量',
		   int buyMinNum;//最小购买数
		   string couponPrice;//优惠价',
		   string discountPrice;//折扣价',
		   string discountRate;//折扣率',
		   string descendingPrice;//减价',
		   string factoryPrice;//出厂价',
		   AreaIceModule areaIceModule;
		   BrandModule brandModule;
		   CategoryModule categoryModule;
		   TypeModule typeModule;
		   CapacityModule capacityModule;
		   UnitModule unitModule;
		   string deniedMessage;
	};
	
	//=====================图片=================
	class FileIceModule extends BaseModule{
		string fileId;//线上文件ID',
	  	string fileUrl;//线上文件URL',
	    string mimeType;//
	    string keyValue;
	    string name;
	    string metaData;
	    string platform;//平台
	};
	
	class FileResult extends Result{
		FileIceModule fileIceModule;
	};
	
	class FileParam extends Paramter{
		FileIceModule fileIceModule;
	};
}; 
