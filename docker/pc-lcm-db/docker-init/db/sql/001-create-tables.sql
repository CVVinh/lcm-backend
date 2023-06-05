-- Project Name : PC-LCM
-- Date/Time    : 2022/12/06 1:23:51
-- Author       : LOSPEC
-- RDBMS Type   : MySQL
-- Application  : A5:SQL Mk-2

SET CHARACTER_SET_CLIENT = utf8mb4;
SET CHARACTER_SET_CONNECTION = utf8mb4;

-- 品目マスタ
create table m_item (
  item_id VARCHAR(36) not null comment '品目ID'
  , item_status CHAR(1) default '1' not null comment 'ステータス:1：有効、9：無効(削除)'
  , is_set CHAR(1) default '0' not null comment '品目セットフラグ:0：個別、1：セット用品目。
セット用品目の内訳は個別のみが対象となる。'
  , item_name VARCHAR(200) not null comment '品目名称'
  , item_name_kana VARCHAR(500) not null comment '品目名称カナ:カナが未指定の場合は品目名称を設定する'
  , item_type_id VARCHAR(36) not null comment 'タイプID'
  , maker_id VARCHAR(36) comment 'メーカーID'
  , maker_model VARCHAR(200) comment 'メーカー型番'
  , jan_code VARCHAR(13) comment 'JANコード'
  , os_id VARCHAR(36) comment 'OS'
  , expiration_date_from DATE not null comment '有効開始日'
  , expiration_date_to DATE not null comment '有効終了日'
  , unit_name VARCHAR(50) comment '単位名:「台」「個」など'
  , order_unit INT not null comment '発注単位数量'
  , order_unit_max INT not null comment '最大発注単位量'
  , item_title VARCHAR(200) not null comment '商品タイトル:未指定の場合は「品目名称」を設定'
  , item_description TEXT comment '商品説明'
  , price INT not null comment '単価'
  , asset_type CHAR(1) not null comment '資産区分:1：償却資産(PCセット)、2：償却資産(PC,機器)、3：償却資産(ソフトウェア)、4：消耗品、5：リース、6：レンタル'
  , created_account_id VARCHAR(36) not null comment '登録者'
  , created_datetime DATETIME not null comment '登録日時'
  , modified_account_id VARCHAR(36) not null comment '更新者'
  , modified_datetime DATETIME not null comment '更新日時'
  , deleted_account_id VARCHAR(36) comment '削除者'
  , deleted_datetime DATETIME comment '削除日時'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint m_item_PKC primary key (item_id)
) comment '品目マスタ:商品用の画像は品目ID+_+連番2桁(01から)でS3上に保管する' ;

create index m_item_IX1
  on m_item(item_name);

create index m_item_IX2
  on m_item(jan_code);

create index m_item_IX3
  on m_item(maker_id);

create index m_item_IX4
  on m_item(maker_model);

create index m_item_IX5
  on m_item(item_type_id);

create index m_item_IX6
  on m_item(expiration_date_from,expiration_date_to);

create index m_item_IX7
  on m_item(item_status,item_id);

-- 品目タイプマスタ
create table m_item_type (
  item_type_id VARCHAR(36) not null comment 'タイプID'
  , item_type_name VARCHAR(400) not null comment 'タイプ名称'
  , can_be_main CHAR(1) default '0' not null comment 'メイン可フラグ:0：不可、1：可（主にPCを想定）'
  , sort_order INT default 1 not null comment '表示順'
  , note TEXT comment '備考'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint m_item_type_PKC primary key (item_type_id)
) comment '品目タイプマスタ:デスクトップセット、ノートセット、デスクトップ、ノート、タブレット、機器、ソフトウェア(ライセンスなし)、ソフトウェア(ライセンスあり)' ;

-- メーカーマスタ
create table m_item_maker (
  maker_id VARCHAR(36) not null comment 'メーカーID'
  , maker_name VARCHAR(200) not null comment 'メーカー名称'
  , sort_order INT default 1 not null comment '表示順'
  , note TEXT comment '備考'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint m_item_maker_PKC primary key (maker_id)
) comment 'メーカーマスタ' ;

-- 品目セットマスタ
create table m_item_set (
  item_id_set VARCHAR(36) not null comment 'セット用品目ID:セット用の品目の品目ID'
  , kitting_master_id VARCHAR(36) comment 'キッティングマスターID'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint m_item_set_PKC primary key (item_id_set)
) comment '品目セットマスタ' ;

-- 品目セット商品マスタ
create table m_item_set_item (
  item_id_set VARCHAR(36) not null comment 'セット用品目ID:セット用品目の品目ID'
  , item_id VARCHAR(36) not null comment '品目ID:セットされる個別の品目ID'
  , is_main CHAR(1) default '0' not null comment 'メインフラグ:0：非メイン、1：メイン品目。
「メイン可」の品目タイプの品目が対象'
  , sort_order INT default 1 not null comment '表示順'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint m_item_set_item_PKC primary key (item_id_set,item_id)
) comment '品目セット商品マスタ' ;

-- キッティングマスタ
create table m_kitting (
  kitting_master_id VARCHAR(36) not null comment 'キッティングマスタID'
  , kitting_master_name VARCHAR(200) not null comment 'キッティングマスタ名称'
  , note TEXT comment '備考'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint m_kitting_PKC primary key (kitting_master_id)
) comment 'キッティングマスタ' ;

-- 調達管理
create table t_procurement (
  procurement_id VARCHAR(36) not null comment '調達ID'
  , procurement_name VARCHAR(200) not null comment '調達名称'
  , procurement_status CHAR(1) default 1 not null comment '調達ステータス:1：作成中、2：見積依頼、3：見積回答、4：承認依頼、5：承認済、6：発注依頼、発注済、9：無効（削除）'
  , is_back CHAR(1) default 0 not null comment '差戻フラグ:0：対象外、1：対象(差戻状態である)'
  , quotation_requester VARCHAR(36) comment '見積依頼者'
  , quotation_request_note VARCHAR(2000) comment '見積依頼備考'
  , quotation_request_datetime DATETIME comment '見積依頼日時'
  , quotation_account_id VARCHAR(36) comment '見積担当者'
  , quotation_note VARCHAR(2000) comment '見積回答備考'
  , quotation_datetime DATETIME comment '見積回答日時'
  , approval_requester VARCHAR(36) comment '承認依頼者'
  , `approval_expiration date` DATE comment '承認期限'
  , approval_request_note VARCHAR(2000) comment '承認依頼備考'
  , approval_request_datetime DATETIME comment '承認依頼日時'
  , approval_account_id VARCHAR(36) comment '承認者'
  , approval_note VARCHAR(2000) comment '承認備考'
  , approval_datetime DATETIME comment '承認日時'
  , ext_approval_id VARCHAR(100) comment '外部承認ID'
  , order_id VARCHAR(36) comment '発注ID:発注時に採番'
  , created_account_id VARCHAR(36) not null comment '登録者'
  , created_datetime DATETIME not null comment '登録日時'
  , modified_account_id VARCHAR(36) not null comment '更新者'
  , modified_datetime DATETIME not null comment '更新日時'
  , deleted_account_id VARCHAR(36) comment '削除者'
  , deleted_datetime DATETIME comment '削除日時'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint t_procurement_PKC primary key (procurement_id)
) comment '調達管理' ;

-- 発注明細
create table t_order (
  order_detail_id INT not null AUTO_INCREMENT comment '発注明細ID:自動採番'
  , procurement_id VARCHAR(36) not null comment '調達ID'
  , item_id VARCHAR(36) not null comment '品目ID'
  , price INT not null comment '単価'
  , quantity INT not null comment '数量'
  , amount INT not null comment '小計'
  , has_users_file CHAR(1) default '0' not null comment '利用者ファイル有無:0：なし、1：あり
実ファイルはS3の以下に格納。
バケット名/{調達ID}/{発注明細ID}+"_users_"+[アップロードした時のファイル名]'
  , has_quotation_file CHAR(1) default '0' not null comment '見積有無:0：なし、1：あり
実ファイルはS3の以下に格納。
バケット名/{調達ID}/{発注明細ID}+"_quotation_"+[アップロードした時のファイル名]：'
  , estimated_arrival_date DATE comment '入荷予定日'
  , estimated_shipping_date DATE comment '出荷予定日'
  , kitting_master_id VARCHAR(36) comment 'キッティングマスタID'
  , record_type VARCHAR(36) comment '計上方式'
  , supplier_id VARCHAR(36) comment '発注先ID'
  , order_on DATE comment '発注日'
  , supplier_order_id VARCHAR(100) comment '発注先受注ID'
  , has_order_file CHAR(1) default '0' comment 'エビデンスファイル有無:0：なし、1：あり
実ファイルはS3の以下に格納。
バケット名/{調達ID}/{発注明細ID}+"_order_"+[アップロードした時のファイル名]'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint t_order_PKC primary key (order_detail_id)
) comment '発注明細' ;

create index t_order_IX1
  on t_order(procurement_id,item_id);

-- 入荷予定資産
create table t_arrive_asset (
  asset_id VARCHAR(36) not null comment '資産ID:資産登録前だが資産IDとする'
  , asset_cd VARCHAR(200) comment '資産コード'
  , inspection_status VARCHAR(50) default 'waiting' not null comment '検品ステータス:waiting：未
pass：合格
failure：不合格'
  , inspection_account_id VARCHAR(36) comment '検品担当者'
  , failure_action VARCHAR(50) default 'waiting' not null comment '不合格処理:waiting：未
return_restock_waiting：返品(再入荷待ち)
return_restocked：返品(再入荷済)
return_no_restock：返品(再入荷なし)'
  , order_detail_id INT not null comment '発注明細ID'
  , arrive_type VARCHAR(50) not null comment '入荷方法:order：発注
bring：持ち込み'
  , item_id VARCHAR(36) comment '品目ID'
  , item_name VARCHAR(200) not null comment '品目名称'
  , item_name_kana VARCHAR(400) not null comment '品目名称カナ'
  , item_type_id VARCHAR(36) not null comment 'タイプID'
  , maker_id VARCHAR(36) comment 'メーカーID'
  , maker_model VARCHAR(200) comment 'メーカー型番'
  , jan_code VARCHAR(13) comment 'JANコード'
  , serial_number VARCHAR(100) comment '物理資産ID'
  , asset_type CHAR(1) not null comment '資産区分:depreciable_asset_set：償却資産(PCセット)
depreciable_asset_hardware：償却資産(PC,機器)
depreciable_asset_software：償却資産(ソフトウェア)
consumables：消耗品
lease：リース
rental：レンタル'
  , base_id VARCHAR(36) comment '入荷拠点ID'
  , estimated_arrive_on DATE comment '入荷予定日'
  , arrive_on DATE comment '入荷日'
  , price INT not null comment '単価'
  , is_asset CHAR(1) default '0' not null comment '資産登録フラグ:0：未、1：済'
  , registered_by VARCHAR(36) not null comment '資産登録者'
  , registered_at DATETIME not null comment '資産登録日時'
  , record_type VARCHAR(50) comment '計上方式'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint t_arrive_asset_PKC primary key (asset_id)
) comment '入荷予定資産:発注時に品目×数量分のレコードを追加' ;

-- 資産
create table t_asset (
  asset_id VARCHAR(36) not null comment '資産ID'
  , asset_name VARCHAR(200) comment '資産名称'
  , asset_name_kana VARCHAR(500) comment '資産名称カナ'
  , asset_cd VARCHAR(100) comment '資産コード'
  , asset_status VARCHAR(50) comment '資産ステータス:stock：在庫
shipping instruction：出荷指示
waiting_kitting：キッティング待ち
kitting：キッティング中
waiting_shipping：出荷待ち
shipped：出荷済
using：利用中
waiting_pickup：集荷待ち
picked_up：集荷済
waiting_repair：修理待ち
being_repaired：修理中
repaired：修理済
waiting_disposal：廃棄待ち
disposing：廃棄中
disposed：廃棄済
depreciation_completed：償却完了
lease_up：リース切れ
rental_return：レンタル返却済'
  , procument_id VARCHAR(36) comment '調達ID'
  , asset_kind VARCHAR(50) comment '資産種別:set_desktop：デスクトップセット
set_laptop：ノートセット
desktop：デスクトップ
laptop：ノート
tablet：タブレット
device：機器
software_without_license：ソフトウェア(ライセンスなし)
software_with_license：ソフトウェア(ライセンスあり)
cloud_license：クラウドライセンス'
  , asset_type VARCHAR(50) comment '資産区分:depreciable_asset_set：償却資産(PCセット)
depreciable_asset_hardware：償却資産(PC,機器)
depreciable_asset_software：償却資産(ソフトウェア)
consumables：消耗品
lease：リース
rental：レンタル'
  , asset_from DATE comment '資産開始日'
  , asset_to DATE comment '資産終了日'
  , parent_asset_id VARCHAR(36) comment '親資産ID'
  , record_type VARCHAR(50) comment '計上方式'
  , kitting_history_id INT comment 'キッティング履歴ID'
  , kitting_status VARCHAR(50) comment 'キッティングステータス'
  , shipping_id INT comment '出荷ID'
  , shipping_status VARCHAR(50) comment '出荷ステータス:waiting：未
shipping_arrangement：出荷手配中
shipped：出荷配送中
completed：完了'
  , use_id INT comment '利用ID'
  , account_id VARCHAR(36) comment '利用者アカウントID'
  , group_id INT comment '利用グループID'
  , base_id INT comment '利用拠点ID'
  , repairing_id INT comment '修理ID'
  , repairing_status VARCHAR(50) comment '修理ステータス:waiting：未
repairing_arrangement：修理手配中
repairing_picked_up：修理配送中
being_repaired：修理中
repaired_shipped：修理後配送中
completed：完'
  , disposal_id INT comment '廃棄ID'
  , disposal_status VARCHAR(50) comment '廃棄ステータス:waiting：未
disposal_arrangement：廃棄手配中
disposal_picked_up：廃棄配送中
disposing：廃棄中
completed：完了'
  , disposal_on DATETIME comment '廃棄日時'
  , returned_on DATETIME comment '返却日時'
  , created_datetime DATETIME comment '登録日時'
  , deleted_datetime DATETIME comment '削除日時'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint t_asset_PKC primary key (asset_id)
) comment '資産' ;

-- 利用情報
create table t_use (
  use_id INT not null AUTO_INCREMENT comment '利用ID'
  , use_status VARCHAR(50) not null comment '利用ステータス'
  , asset_id VARCHAR(36) not null comment '資産ID'
  , use_on_from DATE not null comment '利用開始日'
  , use_on_to DATE not null comment '利用終了日'
  , `アカウントID` VARCHAR(36) not null comment 'アカウントID'
  , `グループID` INT not null comment 'グループID'
  , `拠点ID` INT not null comment '拠点ID'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint t_use_PKC primary key (use_id)
) comment '利用情報' ;

create index t_use_IX1
  on t_use(asset_id,use_on_from);

create index t_use_IX2
  on t_use(`アカウントID`,use_on_from);

-- 償却情報
create table m_asset_depreciation (
  asset_id VARCHAR(36) not null comment '資産ID'
  , `fiscal year` CHAR(4) not null comment '年度:YYYY'
  , amount INT not null comment '費用'
  , created_account_id VARCHAR(36) comment '登録者'
  , created_datetime DATETIME comment '登録日時'
  , modified_account_id VARCHAR(36) comment '更新者'
  , modified_datetime DATETIME comment '更新日時'
  , deleted_account_id VARCHAR(36) comment '削除者'
  , deleted_datetime DATETIME comment '削除日時'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint m_asset_depreciation_PKC primary key (asset_id,`fiscal year`)
) comment '償却情報' ;

-- キッティング情報
create table t_kitting (
  kitting_id INT not null AUTO_INCREMENT comment 'キッティングID'
  , kitting_status VARCHAR(50) default 'waiting' not null comment 'キッティングステータス'
  , asset_id VARCHAR(36) not null comment '資産ID'
  , kitting_at DATETIME comment 'キッティング開始日時'
  , completed_at DATETIME comment 'キッティング完了日時'
  , note TEXT comment '備考'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint t_kitting_PKC primary key (kitting_id)
) comment 'キッティング情報' ;

-- 出荷情報
create table t_shipping (
  shipping_id INT not null AUTO_INCREMENT comment '出荷ID'
  , shipping_reception_status VARCHAR(50) default 'waiting' not null comment '出荷受付ステータス'
  , shipping_status VARCHAR(50) default 'waiting' not null comment '出荷ステータス'
  , asset_id VARCHAR(36) not null comment '資産ID'
  , reception_on DATE not null comment '受付日'
  , working_on DATE comment '作業開始日時'
  , completed_on DATE comment '完了日時'
  , outsourcing_company_id VARCHAR(36) comment '委託先ID'
  , note TEXT comment '備考'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint t_shipping_PKC primary key (shipping_id)
) comment '出荷情報' ;

-- 集荷情報
create table t_pick_up (
  pick_up_id INT not null AUTO_INCREMENT comment '集荷ID'
  , pick_up_status VARCHAR(50) not null comment '集荷ステータス'
  , asset_id VARCHAR(36) not null comment '資産ID'
  , pick_up_arrangement_on DATE comment '集荷手配日'
  , pick_up_scheduled_date DATE comment '集荷予定日'
  , completed_on DATE comment '集荷完了日'
  , outsourcing_company_id VARCHAR(36) comment '委託先ID'
  , note TEXT comment '備考'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint t_pick_up_PKC primary key (pick_up_id)
) comment '集荷情報' ;

-- 修理情報
create table t_repairing (
  repairing_id INT not null AUTO_INCREMENT comment '修理ID'
  , repairing_status VARCHAR(50) not null comment '修理ステータス'
  , asset_id VARCHAR(36) not null comment '資産ID'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint t_repairing_PKC primary key (repairing_id)
) comment '修理情報' ;

-- 廃棄情報
create table t_disposal (
  disposal_id INT not null AUTO_INCREMENT comment '廃棄ID'
  , disposal_status VARCHAR(50) default 'waiting' not null comment '廃棄ステータス'
  , asset_id VARCHAR(36) not null comment '資産ID'
  , note TEXT comment '備考'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint t_disposal_PKC primary key (disposal_id)
) comment '廃棄情報' ;

-- グループマスタ
create table m_group (
  group_id INT not null comment 'グループID:1以上であること'
  , group_name VARCHAR(200) not null comment 'グループ名称'
  , group_cd VARCHAR(200) comment 'グループコード'
  , parent_group_id INT default 0 not null comment '親グループID:0 は親グループが無し'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint m_group_PKC primary key (group_id)
) comment 'グループマスタ' ;

-- グループ連携マスタ
create table m_account_group (
  account_id VARCHAR(36) not null comment 'アカウントID'
  , group_id INT not null comment 'グループID'
  , is_manager CHAR(1) default '0' not null comment '管理者フラグ'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint m_account_group_PKC primary key (account_id,group_id)
) comment 'グループ連携マスタ' ;

-- アカウントマスタ
create table m_account (
  account_id VARCHAR(36) not null comment 'アカウントID'
  , account_cd VARCHAR(200) comment 'アカウントコード:社員番号など利用企業のIDやコードのため'
  , ext_account_id VARCHAR(200) comment '外部アカウントID:cognitoなどの外部認証サービスと連携する場合は設定'
  , account_name VARCHAR(200) not null comment 'アカウント名'
  , email_address VARCHAR(200) not null comment 'メールアドレス'
  , account_status CHAR(1) default '1' not null comment 'ステータス:1：仮登録、2：本登録、9：削除'
  , is_system_manager CHAR(1) default '0' not null comment 'システム管理フラグ:アプリケーションで設定/更新しないこと'
  , created_datetime DATETIME not null comment '登録日時'
  , deleted_datetime DATETIME comment '削除日時'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint m_account_PKC primary key (account_id)
) comment 'アカウントマスタ' ;

-- ロール連携マスタ
create table m_account_role (
  account_id VARCHAR(36) not null comment 'アカウントID'
  , role_id INT not null comment 'ロールID'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint m_account_role_PKC primary key (account_id,role_id)
) comment 'ロール連携マスタ' ;

-- ロールマスタ
create table m_role (
  role_id INT not null comment 'ロールID'
  , role_name VARCHAR(200) not null comment 'ロール名'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint m_role_PKC primary key (role_id)
) comment 'ロールマスタ' ;

-- オペレーション連携マスタ
create table m_role_operation (
  role_id INT not null comment 'ロールID'
  , operation_id INT not null comment 'オペレーションID'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint m_role_operation_PKC primary key (role_id,operation_id)
) comment 'オペレーション連携マスタ' ;

-- オペレーションマスタ
create table m_operation (
  operation_id INT not null comment 'オペレーションID'
  , operation_name VARCHAR(200) not null comment 'オペレーション名'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint m_operation_PKC primary key (operation_id)
) comment 'オペレーションマスタ:フロントのイベント、API等にはオペレーションIDが割り当てられ、そのオペレーションが許可されたアカウントのみ利用できる' ;

-- 拠点連携マスタ
create table m_account_base (
  account_id VARCHAR(36) not null comment 'アカウントID'
  , base_id INT not null comment '拠点ID'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint m_account_base_PKC primary key (account_id,base_id)
) comment '拠点連携マスタ' ;

-- 拠点マスタ
create table m_base (
  base_id INT not null comment '拠点ID'
  , base_cd VARCHAR(200) comment '拠点コード'
  , base_name VARCHAR(200) not null comment '拠点名'
  , zip_code VARCHAR(10) comment '郵便番号'
  , address VARCHAR(400) comment '住所'
  , addressee VARCHAR(200) comment '受取名:配送や郵送時の受信名'
  , telephone_number VARCHAR(200) comment '電話番号'
  , fax_number VARCHAR(200) comment 'FAX番号'
  , e_mail_address VARCHAR(200) comment 'メールアドレス'
  , note TEXT comment '備考'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint m_base_PKC primary key (base_id)
) comment '拠点マスタ' ;

-- 通知
create table t_notification (
  notification_id INT not null comment '通知ID'
  , notification_cd VARCHAR(36) not null comment '通知コード:yyyymmdd0000 通知日時＋連番'
  , title VARCHAR(200) not null comment '件名'
  , body TEXT not null comment '内容'
  , notification_at DATETIME not null comment '通知開始日時'
  , note TEXT comment '備考'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint t_notification_PKC primary key (notification_id)
) comment '通知' ;

-- 通知先
create table t_notification_to (
  notification_to_id INT not null AUTO_INCREMENT comment '通知先ID:自動採番'
  , notification_to_type VARCHAR(100) not null comment '通知先区分:account、group、base'
  , account_id VARCHAR(36) comment 'アカウントID'
  , group_id VARCHAR(36) comment 'グループID'
  , base_id VARCHAR(36) comment '拠点ID'
  , notification_status VARCHAR(100) not null comment '通知ステータス:temporarily'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint t_notification_to_PKC primary key (notification_to_id)
) comment '通知先' ;

-- 委託先マスタ
create table m_outsourcing_company (
  outsourcing_company_id INT not null AUTO_INCREMENT comment '委託先ID'
  , outsourcing_company_name VARCHAR(200) not null comment '委託先名称'
  , area VARCHAR(50) comment 'エリア:hokkaido：北海道
tohoku：東北
kanto_koushinetsu：関東甲信
hokuriku：北陸
tokai：東海
kinki：近畿
chugoku：中国
shikoku：四国
kyushu：九州
okinawa：沖縄'
  , zip_code VARCHAR(10) comment '郵便番号'
  , pref_code VARCHAR(10) comment '都道府県コード'
  , city VARCHAR(200) comment '市区町村'
  , street VARCHAR(200) comment '番地'
  , building VARCHAR(200) comment '建物'
  , pilot_number VARCHAR(200) comment '代表電話番号'
  , department VARCHAR(200) comment '担当部署'
  , pic VARCHAR(200) comment '担当者'
  , direct_number VARCHAR(200) comment '担当電話番号'
  , direct_email_address VARCHAR(200) comment '担当メールアドレス'
  , note TEXT comment '備考'
  , created_account_id VARCHAR(36) comment '登録者'
  , created_datetime DATETIME comment '登録日時'
  , modified_account_id VARCHAR(36) comment '更新者'
  , modified_datetime DATETIME comment '更新日時'
  , deleted_account_id VARCHAR(36) comment '削除者'
  , deleted_datetime DATETIME comment '削除日時'
  , `sort order` INT default 1 not null comment '表示順'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint m_outsourcing_company_PKC primary key (outsourcing_company_id)
) comment '委託先マスタ' ;

-- 発注先マスタ
create table m_supplier (
  supplier_id VARCHAR(36) not null comment '発注先ID'
  , supplier_name VARCHAR(200) not null comment '発注先名称'
  , zip_code VARCHAR(10) comment '郵便番号'
  , pref_code VARCHAR(10) comment '都道府県コード'
  , city VARCHAR(200) comment '市区町村'
  , street VARCHAR(200) comment '番地'
  , building VARCHAR(200) comment '建物'
  , pilot_number VARCHAR(200) comment '代表電話番号'
  , department VARCHAR(200) comment '担当部署'
  , pic VARCHAR(200) comment '担当者'
  , direct_number VARCHAR(200) comment '担当電話番号'
  , direct_email_address VARCHAR(200) comment '担当メールアドレス'
  , note TEXT comment '備考'
  , created_account_id VARCHAR(36) not null comment '登録者'
  , created_datetime DATETIME not null comment '登録日時'
  , modified_account_id VARCHAR(36) not null comment '更新者'
  , modified_datetime DATETIME not null comment '更新日時'
  , deleted_account_id VARCHAR(36) comment '削除者'
  , deleted_datetime DATETIME comment '削除日時'
  , `sort order` INT default 1 not null comment '表示順'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint m_supplier_PKC primary key (supplier_id)
) comment '発注先マスタ' ;


-- ユーザ申請
create table t_user_request (
  request_id INT not null comment '申請ID'
  , group_id INT comment 'グループID'
  , account_id INT comment 'アカウントID'
  , asset_id INT not null comment '資産ID'
  , request_menu INT comment '申請メニュー'
  , request_status INT default 0 not null comment '申請状況'
  , request_type INT default 0 not null comment '申請種類'
  , request_datetime DATETIME default CURRENT_TIMESTAMP not null comment '申請日'
  , request_account_id INT not null comment '申請者ID'
  , request_group_id INT not null comment '申請グループID'
  , substitute_asset_id VARCHAR(36) comment '代替資産ID'
  , request_completion_date DATETIME comment '対応完了希望日'
  , note TEXT comment '要望'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint t_user_request_PKC primary key (request_id)
) comment 'ユーザ申請' ;


-- サポート
create table t_support (
  support_id INT not null comment '問合せID'
  , asset_id INT comment '資産ID'
  , account_id INT not null comment 'アカウントID'
  , group_id INT comment 'グループID'
  , title VARCHAR(200) not null comment 'タイトル'
  , note TEXT comment '対応内容'
  , created_datetime DATETIME default CURRENT_TIMESTAMP not null comment '登録日'
  , created_account_id INT not null comment '登録者'
  , modified_datetime DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日'
  , modified_account_id INT not null comment '更新者ID'
  , completion_from DATETIME comment '完了日'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint t_support_PKC primary key (support_id)
) comment 'サポート' ;


-- サポートメッセージ
create table t_message (
  message_id INT not null comment 'メッセージID'
  , asset_id INT comment '資産ID'
  , account_id INT not null comment 'アカウントID'
  , group_id INT comment 'グループID'
  , title VARCHAR(200) not null comment 'タイトル'
  , message TEXT not null comment 'メッセージ'
  , created_datetime DATETIME default CURRENT_TIMESTAMP not null comment '発信日'
  , created_account_id INT not null comment '送付者ID'
  , version INT default 1 not null comment 'バージョン:楽観的排他で利用'
  , created_at DATETIME default CURRENT_TIMESTAMP not null comment '作成日時:プログラムでは設定しない'
  , created_by VARCHAR(100) not null comment '作成処理:プログラムで設定、API名、関数名'
  , modified_at DATETIME default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null comment '更新日時:プログラムでは設定しない'
  , modified_by VARCHAR(100) not null comment '更新処理:プログラムで設定、API名、関数名'
  , constraint t_message_PKC primary key (message_id)
) comment 'サポートメッセージ' ;