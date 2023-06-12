-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: pclcm_mysql
-- Thời gian đã tạo: Th6 12, 2023 lúc 10:53 AM
-- Phiên bản máy phục vụ: 8.0.23
-- Phiên bản PHP: 8.1.17

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `pclcm`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `alembic_version`
--

CREATE TABLE `alembic_version` (
  `version_num` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `m_account`
--

CREATE TABLE `m_account` (
  `account_id` int NOT NULL COMMENT 'アカウントID',
  `account_cd` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'アカウントコード:社員番号など利用企業のIDやコードのため',
  `ext_account_id` int DEFAULT NULL COMMENT '外部アカウントID:cognitoなどの外部認証サービスと連携する場合は設定',
  `account_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'アカウント名',
  `email_address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'メールアドレス',
  `account_status` int NOT NULL DEFAULT '0' COMMENT 'ステータス:0：仮登録、1：本登録、2：削除',
  `is_system_manager` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'システム管理フラグ:アプリケーションで設定/更新しないこと',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `m_account`
--

INSERT INTO `m_account` (`account_id`, `account_cd`, `ext_account_id`, `account_name`, `email_address`, `account_status`, `is_system_manager`, `version`, `created_at`, `created_by`, `modified_at`, `modified_by`, `deleted_at`, `deleted_by`, `is_deleted`) VALUES
(1, 'code 1', 1, 'user 1', 'user1@gmail.com', 0, 0, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(2, 'code 2', 2, 'user 2', 'user2@gmail.com', 0, 0, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(3, 'code 3', 3, 'user 3', 'user3@gmail.com', 0, 0, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(4, 'code 4', 4, 'user 4', 'user4@gmail.com', 0, 0, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(5, 'code 5', 5, 'user 5', 'user5@gmail.com', 0, 0, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(6, 'code 6', 6, 'user 6', 'user6@gmail.com', 0, 0, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(7, 'code 7', 7, 'user 7', 'user7@gmail.com', 0, 0, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(8, 'code 8', 8, 'user 8', 'user8@gmail.com', 0, 0, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(9, 'code 9', 9, 'user 9', 'user9@gmail.com', 0, 0, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(10, 'code 10', 10, 'user 10', 'user10@gmail.com', 0, 0, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `m_account_base`
--

CREATE TABLE `m_account_base` (
  `account_base_id` int NOT NULL COMMENT 'アカウントベースID',
  `account_id` int DEFAULT NULL COMMENT 'アカウントID',
  `base_id` int DEFAULT NULL COMMENT '拠点ID',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `m_account_group`
--

CREATE TABLE `m_account_group` (
  `account_group_id` int NOT NULL,
  `account_id` int NOT NULL COMMENT 'アカウントID',
  `group_id` int DEFAULT NULL COMMENT 'グループID',
  `is_manager` tinyint(1) NOT NULL DEFAULT '0' COMMENT '管理者フラグ',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `m_account_group`
--

INSERT INTO `m_account_group` (`account_group_id`, `account_id`, `group_id`, `is_manager`, `version`, `created_at`, `created_by`, `modified_at`, `modified_by`, `deleted_at`, `deleted_by`, `is_deleted`) VALUES
(1, 1, 1, 1, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(2, 2, 1, 2, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(3, 3, 1, 3, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(4, 4, 2, 5, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(5, 5, 2, 6, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(6, 6, 2, 7, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(7, 7, 3, 4, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(8, 8, 3, 5, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(9, 10, 3, 6, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(10, 10, 10, 8, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(11, 10, 10, 9, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(12, 10, 10, 10, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(13, 10, 8, 2, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(14, 10, 8, 3, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(15, 10, 8, 4, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(16, 10, 5, 4, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(17, 10, 5, 5, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(18, 10, 7, 7, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(19, 10, 7, 8, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `m_account_role`
--

CREATE TABLE `m_account_role` (
  `account_id` int NOT NULL COMMENT 'アカウントID',
  `role_id` int DEFAULT NULL COMMENT 'ロールID',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `m_base`
--

CREATE TABLE `m_base` (
  `base_id` int NOT NULL COMMENT '拠点ID',
  `base_cd` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '拠点コード',
  `base_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '拠点名',
  `zip_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '郵便番号',
  `pref_code` int NOT NULL COMMENT '都道府県コード',
  `address` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '住所',
  `addressee` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '受取名:配送や郵送時の受信名',
  `telephone_number` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '電話番号',
  `fax_number` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'FAX番号',
  `e_mail_address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'メールアドレス',
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '備考',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `m_base`
--

INSERT INTO `m_base` (`base_id`, `base_cd`, `base_name`, `zip_code`, `pref_code`, `address`, `addressee`, `telephone_number`, `fax_number`, `e_mail_address`, `note`, `version`, `created_at`, `created_by`, `modified_at`, `modified_by`, `deleted_at`, `deleted_by`, `is_deleted`) VALUES
(1, 'code 1', 'base 1', '111-1234', 22, 'address 1', 'addressee 1', NULL, NULL, NULL, NULL, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(2, 'code 2', 'base 2', '111-1235', 13, 'address 2', 'addressee 2', NULL, NULL, NULL, NULL, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(3, 'code 3', 'base 3', '111-1236', 11, 'address 3', 'addressee 3', NULL, NULL, NULL, NULL, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(4, 'code 4', 'base 4', '111-1237', 13, 'address 4', 'addressee 4', NULL, NULL, NULL, NULL, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(5, 'code 5', 'base 5', '111-1238', 32, 'address 5', 'addressee 5', NULL, NULL, NULL, NULL, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(6, 'code 6', 'base 6', '111-1239', 42, 'address 6', 'addressee 6', NULL, NULL, NULL, NULL, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(7, 'code 7', 'base 7', '111-1240', 22, 'address 7', 'addressee 7', NULL, NULL, NULL, NULL, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(8, 'code 8', 'base 8', '111-1241', 11, 'address 8', 'addressee 8', NULL, NULL, NULL, NULL, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(9, 'code 9', 'base 9', '111-1242', 44, 'address 9', 'addressee 9', NULL, NULL, NULL, NULL, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(10, 'code 10', 'base 10', '111-1243', 44, 'address 10', 'addressee 10', NULL, NULL, NULL, NULL, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `m_depreciation_rule`
--

CREATE TABLE `m_depreciation_rule` (
  `depreciation_rule_id` int NOT NULL,
  `depreciation_rule_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fiscal_year` char(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '年度:YYYY',
  `amount_per_year` float DEFAULT NULL COMMENT '費用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済',
  `base_year` date DEFAULT NULL COMMENT '費用'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `m_depreciation_rule`
--

INSERT INTO `m_depreciation_rule` (`depreciation_rule_id`, `depreciation_rule_name`, `fiscal_year`, `amount_per_year`, `created_at`, `created_by`, `modified_at`, `modified_by`, `deleted_at`, `deleted_by`, `is_deleted`, `base_year`) VALUES
(1, 'rule 1', '2023', NULL, '2023-02-22 17:38:07', NULL, '2023-02-22 17:38:07', NULL, NULL, NULL, 0, '2023-06-06');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `m_gen_code`
--

CREATE TABLE `m_gen_code` (
  `gen_code_id` int NOT NULL,
  `table_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field_value` int DEFAULT NULL,
  `field_display_label` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `m_gen_code`
--

INSERT INTO `m_gen_code` (`gen_code_id`, `table_name`, `field_name`, `field_value`, `field_display_label`) VALUES
(1, 't_asset', 'assetStatus', 0, '在庫'),
(2, 't_asset', 'assetStatus', 1, 'キッティング中'),
(3, 't_asset', 'assetStatus', 2, '出荷中'),
(4, 't_asset', 'assetStatus', 3, '集荷中'),
(5, 't_asset', 'assetStatus', 4, '修理中'),
(6, 't_asset', 'assetStatus', 5, '廃棄中'),
(7, 't_asset', 'assetStatus', 6, '利用中'),
(8, 't_asset', 'assetStatus', 7, '廃棄済み'),
(9, 't_kitting', 'kittingStatus', 0, '未キッティング'),
(10, 't_kitting', 'kittingStatus', 1, 'キッティング中'),
(11, 't_kitting', 'kittingStatus', 2, 'キッティング完了'),
(12, 't_shipping', 'shippingStatus', 0, '未出荷'),
(13, 't_shipping', 'shippingStatus', 1, '出荷中'),
(14, 't_shipping', 'shippingStatus', 2, '出荷完了'),
(15, 't_shipping', 'shippingReceptionStatus', 0, '未出荷受付'),
(16, 't_shipping', 'shippingReceptionStatus', 1, '出荷受付中'),
(17, 't_shipping', 'shippingReceptionStatus', 2, '出荷受付完了'),
(18, 't_pick_up', 'pickUpStatus', 0, '未集荷'),
(19, 't_pick_up', 'pickUpStatus', 1, '集荷中'),
(20, 't_pick_up', 'pickUpStatus', 2, '集荷完了'),
(21, 't_repairing', 'repairingStatus', 0, '未修理'),
(22, 't_repairing', 'repairingStatus', 1, '修理中'),
(23, 't_repairing', 'repairingStatus', 2, '修理完了'),
(24, 't_disposal', 'disposalStatus', 0, '未廃棄'),
(25, 't_disposal', 'disposalStatus', 1, '廃棄中'),
(26, 't_disposal', 'disposalStatus', 2, '廃棄完了'),
(27, 't_use', 'useStatus', 0, '未利用'),
(28, 't_use', 'useStatus', 1, '利用中'),
(29, 't_use', 'useStatus', 2, '利用完了'),
(30, 'm_account', 'accountStatus', 0, '仮登録'),
(31, 'm_account', 'accountStatus', 1, '本登録'),
(32, 'm_account', 'accountStatus', 2, '削除'),
(33, 't_procurement', 'procurementStatus', 0, '見積依頼'),
(34, 't_procurement', 'procurementStatus', 1, '回答'),
(35, 't_procurement', 'procurementStatus', 2, '承認依頼'),
(36, 't_procurement', 'procurementStatus', 3, '承認'),
(37, 't_procurement', 'procurementStatus', 4, '入荷予定登録・償却登録'),
(38, 't_procurement', 'procurementStatus', 5, '発注'),
(39, 't_procurement', 'procurementStatus', 6, '入荷済み'),
(40, 't_arrival', 'inspectionStatus', 0, '未検品'),
(41, 't_arrival', 'inspectionStatus', 1, '合格'),
(42, 't_arrival', 'inspectionStatus', 2, '不合格'),
(43, 't_arrival', 'arrivalType', 0, '発注'),
(44, 't_arrival', 'arrivalType', 1, '持ち込み'),
(45, 't_arrival', 'failureAction', 0, '未'),
(46, 't_arrival', 'failureAction', 1, '返品(再入荷待ち)'),
(47, 't_arrival', 'failureAction', 2, '返品(再入荷なし)'),
(48, 'm_item', 'assetType', 0, '一般'),
(49, 'm_item', 'assetType', 1, 'ライセンス'),
(50, 't_asset', 'assetType', 0, '償却資産(PCセット)'),
(51, 't_asset', 'assetType', 1, '償却資産(PC,機器)'),
(52, 't_asset', 'assetType', 2, '償却資産(ソフトウェア)'),
(53, 't_asset', 'assetType', 3, '消耗品'),
(54, 't_asset', 'assetType', 4, 'リース'),
(55, 't_asset', 'assetType', 5, 'レンタル'),
(56, 't_notification_to', 'notificationToType', 0, 'アカウント'),
(57, 't_notification_to', 'notificationToType', 1, 'グループ'),
(58, 't_notification_to', 'notificationToType', 2, 'ベース'),
(59, 'm_item_set', 'itemSetType', 0, 'PCセット'),
(60, 'm_asset_set', 'assetSetType', 0, 'PCセット'),
(61, 't_pick_up', 'pickUpType', 0, '集荷待ち（返却）'),
(62, 't_pick_up', 'pickUpType', 1, '集荷待ち（修理）');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `m_group`
--

CREATE TABLE `m_group` (
  `group_id` int NOT NULL COMMENT 'グループID:1以上であること',
  `group_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'グループ名称',
  `group_cd` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'グループコード',
  `parent_group_id` int NOT NULL DEFAULT '1' COMMENT '親グループID:0 は親グループが無し',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `m_group`
--

INSERT INTO `m_group` (`group_id`, `group_name`, `group_cd`, `parent_group_id`, `version`, `created_at`, `created_by`, `modified_at`, `modified_by`, `deleted_at`, `deleted_by`, `is_deleted`) VALUES
(1, 'Group 1', 'code 1', 1, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(2, 'Group 2', 'code 2', 2, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(3, 'Group 3', 'code 3', 3, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(4, 'Group 4', 'code 4', 4, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(5, 'Group 5', 'code 5', 5, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(6, 'Group 6', 'code 6', 6, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(7, 'Group 7', 'code 7', 7, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(8, 'Group 8', 'code 8', 8, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(9, 'Group 9', 'code 9', 9, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0),
(10, 'Group 10', 'code 10', 10, 1, '2023-02-21 14:51:41', NULL, '2023-02-21 14:51:41', NULL, NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `m_item`
--

CREATE TABLE `m_item` (
  `item_id` int NOT NULL COMMENT '品目ID',
  `item_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '品目名称',
  `jan_code` varchar(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'JANコード',
  `maker_id` int NOT NULL COMMENT 'メーカーID',
  `maker_model` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'メーカー型番',
  `asset_type` int NOT NULL DEFAULT '0' COMMENT '資産区分:0：一般、1：ライセンス',
  `expiration_date_from` date DEFAULT NULL COMMENT '有効開始日',
  `expiration_date_to` date DEFAULT NULL COMMENT '有効終了日',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `os_id` int DEFAULT NULL COMMENT 'OS',
  `order_unit` int DEFAULT NULL COMMENT '発注単位数量',
  `order_unit_max` int DEFAULT NULL COMMENT '最大発注単位量',
  `item_title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '商品タイトル:未指定の場合は「品目名称」を設定',
  `item_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '商品説明',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済',
  `serial_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '物理資産ID',
  `price` int DEFAULT NULL COMMENT '単価',
  `tax` int DEFAULT NULL COMMENT '税',
  `tax_inc_price` float DEFAULT NULL COMMENT '税には価格が含まれます'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `m_item`
--

INSERT INTO `m_item` (`item_id`, `item_name`, `jan_code`, `maker_id`, `maker_model`, `asset_type`, `expiration_date_from`, `expiration_date_to`, `version`, `os_id`, `order_unit`, `order_unit_max`, `item_title`, `item_description`, `created_at`, `created_by`, `modified_at`, `modified_by`, `deleted_at`, `deleted_by`, `is_deleted`, `serial_number`, `price`, `tax`, `tax_inc_price`) VALUES
(1, 'Computer mouse', 'Code 1', 1, 'model 1', 0, '2023-01-01', '2023-02-01', 1, 0, 1, 5, 'title 1', 'description 1', '2023-02-03 17:15:51', NULL, '2023-02-03 17:15:51', NULL, NULL, NULL, 0, 'serial number 1', 8000, 10, 8800),
(2, 'Keyboard', 'Code 2', 2, 'model 2', 0, '2023-01-02', '2023-02-02', 1, 0, 2, 8, 'title 2', 'description 2', '2023-02-03 17:15:51', NULL, '2023-02-03 17:15:51', NULL, NULL, NULL, 0, 'serial number 2', 72000, 10, 79200),
(3, 'CPU', 'Code 3', 3, 'model 3', 0, '2023-01-03', '2023-02-03', 1, 0, 3, 11, 'title 3', 'description 3', '2023-02-03 17:15:51', NULL, '2023-02-03 17:15:51', NULL, NULL, NULL, 0, 'serial number 3', 136000, 10, 149600),
(4, 'TV', 'Code 4', 4, 'model 4', 0, '2023-01-04', '2023-02-04', 1, 0, 4, 14, 'title 4', 'description 4', '2023-02-03 17:15:51', NULL, '2023-02-03 17:15:51', NULL, NULL, NULL, 0, 'serial number 4', 200000, 10, 220000),
(5, 'RAM', 'Code 5', 5, 'model 5', 0, '2023-01-05', '2023-02-05', 1, 0, 5, 17, 'title 5', 'description 5', '2023-02-03 17:15:51', NULL, '2023-02-03 17:15:51', NULL, NULL, NULL, 0, 'serial number 5', 264000, 10, 290400),
(6, 'Network card', 'Code 6', 6, 'model 6', 0, '2023-01-06', '2023-02-06', 1, 0, 6, 20, 'title 6', 'description 6', '2023-02-03 17:15:51', NULL, '2023-02-03 17:15:51', NULL, NULL, NULL, 0, 'serial number 6', 328000, 10, 360800),
(7, 'Screen', 'Code 7', 7, 'model 7', 0, '2023-01-07', '2023-02-07', 1, 0, 7, 23, 'title 7', 'description 7', '2023-02-03 17:15:51', NULL, '2023-02-03 17:15:51', NULL, NULL, NULL, 0, 'serial number 7', 392000, 10, 431200),
(8, 'Headphone', 'Code 8', 8, 'model 8', 0, '2023-02-07', '2023-03-07', 1, 0, 8, 26, 'title 8', 'description 8', '2023-02-03 17:15:51', NULL, '2023-02-03 17:15:51', NULL, NULL, NULL, 0, 'serial number 8', 456000, 20, 547200),
(9, 'Projector', 'Code 9', 9, 'model 9', 0, '2023-02-08', '2023-03-08', 1, 0, 9, 29, 'title 9', 'description 9', '2023-02-03 17:15:51', NULL, '2023-02-03 17:15:51', NULL, NULL, NULL, 0, 'serial number 9', 520000, 20, 624000),
(10, 'Loudspeaker', 'Code 10', 3, 'model 10', 0, '2023-02-09', '2023-03-09', 1, 0, 10, 32, 'title 10', 'description 10', '2023-02-03 17:15:51', NULL, '2023-02-03 17:15:51', NULL, NULL, NULL, 0, 'serial number 10', 584000, 20, 700800),
(11, 'Software 1', 'Code 11', 4, 'model 11', 1, '2023-02-10', '2023-03-10', 1, 1, 2, 8, 'title 11', 'description 11', '2023-02-03 17:15:51', NULL, '2023-02-03 17:15:51', NULL, NULL, NULL, 0, 'serial number 11', 648000, 20, 777600),
(12, 'Software 2', 'Code 12', 5, 'model 12', 1, '2023-02-11', '2023-03-11', 1, 1, 7, 10, 'title 12', 'description 12', '2023-02-03 17:15:51', NULL, '2023-02-03 17:15:51', NULL, NULL, NULL, 0, 'serial number 12', 712000, 20, 854400),
(13, 'Software 3', 'Code 13', 6, 'model 13', 1, '2023-02-12', '2023-03-12', 1, 1, 12, 12, 'title 13', 'description 13', '2023-02-03 17:15:51', NULL, '2023-02-03 17:15:51', NULL, NULL, NULL, 0, 'serial number 13', 776000, 20, 931200),
(14, 'Software 4', 'Code 14', 12, 'model 14', 1, '2022-12-12', '2023-01-07', 1, 1, 17, 14, 'title 14', 'description 14', '2023-02-03 17:15:51', NULL, '2023-02-03 17:15:51', NULL, NULL, NULL, 0, 'serial number 14', 840000, 15, 966000),
(15, 'Software 5', 'Code 15', 13, 'model 15', 1, '2022-12-13', '2023-01-08', 1, 1, 22, 16, 'title 15', 'description 15', '2023-02-03 17:15:51', NULL, '2023-02-03 17:15:51', NULL, NULL, NULL, 0, 'serial number 15', 904000, 15, 1039600),
(16, 'Microsoft Windows', 'Code 16', 14, 'model 16', 1, '2022-12-14', '2023-01-09', 1, 0, 27, 18, 'title 16', 'description 16', '2023-02-03 17:15:51', NULL, '2023-02-03 17:15:51', NULL, NULL, NULL, 0, 'serial number 16', 968000, 15, 1113200),
(17, 'MacOS', 'Code 17', 15, 'model 17', 1, '2022-12-15', '2023-01-10', 1, 0, 32, 20, 'title 17', 'description 17', '2023-02-03 17:15:51', NULL, '2023-02-03 17:15:51', NULL, NULL, NULL, 0, 'serial number 17', 1032000, 15, 1186800),
(18, 'Ubuntu', 'Code 18', 16, 'model 18', 1, '2022-12-16', '2023-01-11', 1, 0, 37, 22, 'title 18', 'description 18', '2023-02-03 17:15:51', NULL, '2023-02-03 17:15:51', NULL, NULL, NULL, 0, 'serial number 18', 1096000, 15, 1260400),
(19, 'CentOS', 'Code 19', 17, 'model 19', 1, '2022-12-17', '2023-01-12', 1, 0, 42, 24, 'title 19', 'description 19', '2023-02-03 17:15:51', NULL, '2023-02-03 17:15:51', NULL, NULL, NULL, 0, 'serial number 19', 1160000, 15, 1334000),
(20, 'Kali Linux', 'Code 20', 18, 'model 20', 1, '2022-12-31', '2023-02-01', 1, 0, 15, 18, 'title 20', 'description 20', '2023-02-03 17:15:51', NULL, '2023-02-03 17:15:51', NULL, NULL, NULL, 0, 'serial number 20', 1224000, 15, 1407600),
(21, 'item name 3', NULL, 1, NULL, 1, '2022-12-27', '2023-12-27', 1, NULL, 5, 10, 'item title 3', NULL, '2023-02-23 11:09:41', NULL, '2023-02-23 11:09:41', NULL, '2023-02-23 13:06:29', NULL, 1, NULL, 100, 8, 108),
(22, 'item name 3', NULL, 1, NULL, 1, '2022-12-27', '2023-12-27', 1, NULL, 5, 10, 'item title 3', NULL, '2023-02-23 11:10:35', NULL, '2023-02-23 11:10:35', NULL, '2023-02-23 13:06:27', NULL, 1, NULL, 100, 8, 108);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `m_item_set`
--

CREATE TABLE `m_item_set` (
  `item_id_set` int NOT NULL COMMENT 'セット用品目ID:セット用の品目の品目ID',
  `item_set_type` int NOT NULL DEFAULT '0',
  `item_set_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_set_jan_code` varchar(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_set_maker_id` int NOT NULL,
  `item_set_maker_model` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_set_os` int NOT NULL DEFAULT '0',
  `item_set_expiration_date_from` date DEFAULT NULL,
  `item_set_expiration_date_to` date DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済',
  `tax_inc_price` float DEFAULT NULL COMMENT '税には価格が含まれます'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `m_item_set`
--

INSERT INTO `m_item_set` (`item_id_set`, `item_set_type`, `item_set_name`, `item_set_jan_code`, `item_set_maker_id`, `item_set_maker_model`, `item_set_os`, `item_set_expiration_date_from`, `item_set_expiration_date_to`, `created_at`, `created_by`, `modified_at`, `modified_by`, `deleted_at`, `deleted_by`, `is_deleted`, `tax_inc_price`) VALUES
(1, 0, 'item set 1', 'code 1', 9, 'model 1', 0, '2023-02-17', '2023-02-21', '2023-02-21 15:42:37', NULL, '2023-02-21 15:42:37', NULL, NULL, NULL, 0, 668800),
(2, 1, 'item set 2', 'code 2', 12, 'model 2', 1, '2023-02-22', '2023-02-27', '2023-02-21 15:43:54', NULL, '2023-02-21 15:43:54', NULL, NULL, NULL, 0, 4568800),
(3, 0, 'item set 3', 'code 3', 16, 'model 3', 0, '2023-02-04', '2023-02-28', '2023-02-21 15:44:37', NULL, '2023-02-21 15:44:37', NULL, NULL, NULL, 0, 1615200),
(4, 1, 'item set 4', 'code 4', 16, 'model 4', 0, '2023-02-23', '2023-02-25', '2023-02-21 15:45:30', NULL, '2023-02-21 15:45:30', NULL, NULL, NULL, 0, 6302000),
(5, 1, 'item set 5', 'code 5', 14, 'model 5', 0, '2023-02-24', '2023-02-28', '2023-02-21 15:46:15', NULL, '2023-02-21 15:46:15', NULL, NULL, NULL, 0, 993600);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `m_item_set_item`
--

CREATE TABLE `m_item_set_item` (
  `item_set_item_id` int NOT NULL,
  `item_id_set` int NOT NULL,
  `item_id` int NOT NULL COMMENT '品目ID:セットされる個別の品目ID',
  `is_main` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'メインフラグ:0：非メイン、1：メイン品目。「メイン可」の品目タイプの品目が対象',
  `sort_order` int NOT NULL DEFAULT '1' COMMENT '表示順',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `m_item_set_item`
--

INSERT INTO `m_item_set_item` (`item_set_item_id`, `item_id_set`, `item_id`, `is_main`, `sort_order`, `version`, `created_at`, `created_by`, `modified_at`, `modified_by`, `deleted_at`, `deleted_by`, `is_deleted`) VALUES
(1, 1, 7, 1, 1, 1, '2023-02-21 15:42:37', NULL, '2023-02-21 15:42:37', NULL, NULL, NULL, 0),
(2, 1, 1, 0, 1, 1, '2023-02-21 15:42:37', NULL, '2023-02-21 15:42:37', NULL, NULL, NULL, 0),
(3, 1, 2, 0, 1, 1, '2023-02-21 15:42:37', NULL, '2023-02-21 15:42:37', NULL, NULL, NULL, 0),
(4, 1, 3, 0, 1, 1, '2023-02-21 15:42:37', NULL, '2023-02-21 15:42:37', NULL, NULL, NULL, 0),
(5, 2, 11, 1, 1, 1, '2023-02-21 15:43:54', NULL, '2023-02-21 15:43:54', NULL, NULL, NULL, 0),
(6, 2, 12, 0, 1, 1, '2023-02-21 15:43:54', NULL, '2023-02-21 15:43:54', NULL, NULL, NULL, 0),
(7, 2, 13, 0, 1, 1, '2023-02-21 15:43:54', NULL, '2023-02-21 15:43:54', NULL, NULL, NULL, 0),
(8, 2, 14, 0, 1, 1, '2023-02-21 15:43:54', NULL, '2023-02-21 15:43:54', NULL, NULL, NULL, 0),
(9, 2, 15, 0, 1, 1, '2023-02-21 15:43:54', NULL, '2023-02-21 15:43:54', NULL, NULL, NULL, 0),
(10, 3, 5, 1, 1, 1, '2023-02-21 15:44:37', NULL, '2023-02-21 15:44:37', NULL, NULL, NULL, 0),
(11, 3, 10, 0, 1, 1, '2023-02-21 15:44:37', NULL, '2023-02-21 15:44:37', NULL, NULL, NULL, 0),
(12, 3, 9, 0, 1, 1, '2023-02-21 15:44:37', NULL, '2023-02-21 15:44:37', NULL, NULL, NULL, 0),
(13, 4, 16, 1, 1, 1, '2023-02-21 15:45:30', NULL, '2023-02-21 15:45:30', NULL, NULL, NULL, 0),
(14, 4, 17, 0, 1, 1, '2023-02-21 15:45:30', NULL, '2023-02-21 15:45:30', NULL, NULL, NULL, 0),
(15, 4, 19, 0, 1, 1, '2023-02-21 15:45:30', NULL, '2023-02-21 15:45:30', NULL, NULL, NULL, 0),
(16, 4, 18, 0, 1, 1, '2023-02-21 15:45:30', NULL, '2023-02-21 15:45:30', NULL, NULL, NULL, 0),
(17, 4, 20, 0, 1, 1, '2023-02-21 15:45:30', NULL, '2023-02-21 15:45:30', NULL, NULL, NULL, 0),
(18, 5, 6, 1, 1, 1, '2023-02-21 15:46:15', NULL, '2023-02-21 15:46:15', NULL, NULL, NULL, 0),
(19, 5, 9, 0, 1, 1, '2023-02-21 15:46:15', NULL, '2023-02-21 15:46:15', NULL, NULL, NULL, 0),
(20, 5, 1, 0, 1, 1, '2023-02-21 15:46:15', NULL, '2023-02-21 15:46:15', NULL, NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `m_item_type`
--

CREATE TABLE `m_item_type` (
  `item_type_id` int NOT NULL COMMENT 'タイプID',
  `item_type_name` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'タイプ名称',
  `can_be_main` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'メイン可フラグ:0：不可、1：可（主にPCを想定）',
  `sort_order` int NOT NULL DEFAULT '1' COMMENT '表示順',
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '備考',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `m_item_type`
--

INSERT INTO `m_item_type` (`item_type_id`, `item_type_name`, `can_be_main`, `sort_order`, `note`, `version`, `created_at`, `created_by`, `modified_at`, `modified_by`, `deleted_at`, `deleted_by`, `is_deleted`) VALUES
(1, 'item_type 1', 0, 1, 'note', 1, '2023-06-08 18:53:00', NULL, '2023-06-08 18:53:00', NULL, NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `m_kitting`
--

CREATE TABLE `m_kitting` (
  `kitting_master_id` int NOT NULL COMMENT 'キッティングマスタID',
  `kitting_master_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'キッティングマスタ名称',
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '備考',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済',
  `master_pc_number` int DEFAULT NULL COMMENT 'マスターPC番号',
  `kitting_method` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'キッティング方法'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `m_kitting`
--

INSERT INTO `m_kitting` (`kitting_master_id`, `kitting_master_name`, `note`, `version`, `created_at`, `created_by`, `modified_at`, `modified_by`, `deleted_at`, `deleted_by`, `is_deleted`, `master_pc_number`, `kitting_method`) VALUES
(1, 'kitting master 1', NULL, 1, '2023-02-22 17:34:39', NULL, '2023-02-22 17:34:39', NULL, NULL, NULL, 0, NULL, NULL),
(2, 'kitting master 2', NULL, 1, '2023-02-22 17:34:39', NULL, '2023-02-22 17:34:39', NULL, NULL, NULL, 0, NULL, NULL),
(3, 'kitting master 3', NULL, 1, '2023-02-22 17:34:39', NULL, '2023-02-22 17:34:39', NULL, NULL, NULL, 0, NULL, NULL),
(4, 'kitting master 4', NULL, 1, '2023-02-22 17:34:39', NULL, '2023-02-22 17:34:39', NULL, NULL, NULL, 0, NULL, NULL),
(5, 'kitting master 5', NULL, 1, '2023-02-22 17:34:39', NULL, '2023-02-22 17:34:39', NULL, NULL, NULL, 0, NULL, NULL),
(6, 'kitting master 6', NULL, 1, '2023-02-22 17:34:39', NULL, '2023-02-22 17:34:39', NULL, NULL, NULL, 0, NULL, NULL),
(7, 'kitting master 7', NULL, 1, '2023-02-22 17:34:39', NULL, '2023-02-22 17:34:39', NULL, NULL, NULL, 0, NULL, NULL),
(8, 'kitting master 8', NULL, 1, '2023-02-22 17:34:39', NULL, '2023-02-22 17:34:39', NULL, NULL, NULL, 0, NULL, NULL),
(9, 'kitting master 9', NULL, 1, '2023-02-22 17:34:39', NULL, '2023-02-22 17:34:39', NULL, NULL, NULL, 0, NULL, NULL),
(10, 'kitting master 10', NULL, 1, '2023-02-22 17:34:39', NULL, '2023-02-22 17:34:39', NULL, NULL, NULL, 0, NULL, NULL),
(11, 'kitting master 11', NULL, 1, '2023-02-22 17:34:39', NULL, '2023-02-22 17:34:39', NULL, NULL, NULL, 0, NULL, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `m_maker`
--

CREATE TABLE `m_maker` (
  `maker_id` int NOT NULL COMMENT 'メーカーID',
  `maker_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'メーカー名称',
  `sort_order` int NOT NULL DEFAULT '1' COMMENT '表示順',
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '備考',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `area` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'エリア:hokkaido：北海道, tohoku：東北, kanto_koushinetsu：関東甲信, hokuriku：北陸, tokai：東海,kinki：近畿,chugoku：中国,shikoku：四国,kyushu：九州,okinawa：沖縄',
  `zip_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '郵便番号',
  `pref_code` int NOT NULL COMMENT '都道府県コード',
  `city` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '市区町村',
  `street` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '番地',
  `building` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '建物',
  `pilot_number` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '代表電話番号',
  `department` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '担当部署',
  `pic` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '担当者',
  `direct_number` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '担当電話番号',
  `direct_email_address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '担当メールアドレス',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `m_maker`
--

INSERT INTO `m_maker` (`maker_id`, `maker_name`, `sort_order`, `note`, `version`, `area`, `zip_code`, `pref_code`, `city`, `street`, `building`, `pilot_number`, `department`, `pic`, `direct_number`, `direct_email_address`, `created_at`, `created_by`, `modified_at`, `modified_by`, `deleted_at`, `deleted_by`, `is_deleted`) VALUES
(1, 'maker 1', 1, 'note 1', 1, '日本', '111-8712', 4, 'city 1', 'street 1', 'building 1', '12345678', 'Department 1', 'pic 1', '09123456789', 'maker1@gmail.com', '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(2, 'maker 2', 1, 'note 2', 1, '日本', '111-8713', 9, 'city 2', 'street 2', 'building 2', '18312679', 'Department 2', 'pic 2', '09122343432', 'maker2@gmail.com', '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(3, 'maker 3', 1, 'note 3', 1, '日本', '111-8714', 32, 'city 3', 'street 3', 'building 3', '18312680', 'Department 3', 'pic 3', '09167865332', 'maker3@gmail.com', '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(4, 'maker 4', 1, 'note 4', 1, '日本', '111-8715', 34, 'city 4', 'street 4', 'building 4', '18312681', 'Department 4', 'pic 4', '09167865332', 'maker4@gmail.com', '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(5, 'maker 5', 1, 'note 5', 1, '日本', '111-8716', 12, 'city 5', 'street 5', 'building 5', '18312682', 'Department 5', 'pic 5', '09167865332', 'maker5@gmail.com', '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(6, 'maker 6', 1, 'note 6', 1, '日本', '111-8717', 22, 'city 6', 'street 6', 'building 6', '18345679', 'Department 6', 'pic 6', '09167865332', 'maker6@gmail.com', '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(7, 'maker 7', 1, 'note 7', 1, 'その他', '111-8718', 48, 'city 7', 'street 7', 'building 7', '18345680', 'Department 7', 'pic 7', '09167865332', 'maker7@gmail.com', '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(8, 'maker 8', 1, 'note 8', 1, 'その他', '111-8719', 48, 'city 8', 'street 8', 'building 8', '18345681', 'Department 8', 'pic 8', '09167865332', 'maker8@gmail.com', '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(9, 'maker 9', 1, 'note 9', 1, 'その他', '111-8720', 48, 'city 9', 'street 9', 'building 9', '18345682', 'Department 9', 'pic 9', '09123464563', 'maker9@gmail.com', '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(10, 'maker 10', 1, 'note 10', 1, 'その他', '111-8721', 48, 'city 10', 'street 10', 'building 10', '18345683', 'Department 10', 'pic 10', '09122343432', 'maker10@gmail.com', '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(11, 'maker 11', 1, 'note 11', 1, 'その他', '111-8722', 48, 'city 11', 'street 11', 'building 11', '18345684', 'Department 11', 'pic 11', '09167865332', 'maker11@gmail.com', '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(12, 'maker 12', 1, 'note 12', 1, '日本', '111-8723', 33, 'city 12', 'street 12', 'building 12', '18234449', 'Department 12', 'pic 12', '09123464563', 'maker12@gmail.com', '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(13, 'maker 13', 1, 'note 13', 1, '日本', '111-8724', 35, 'city 13', 'street 13', 'building 13', '18234450', 'Department 13', 'pic 13', '09122343432', 'maker13@gmail.com', '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(14, 'maker 14', 1, 'note 14', 1, '日本', '111-8725', 13, 'city 14', 'street 14', 'building 14', '18234451', 'Department 14', 'pic 14', '09123456789', 'maker14@gmail.com', '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(15, 'maker 15', 1, 'note 15', 1, '日本', '111-8726', 23, 'city 15', 'street 15', 'building 15', '18234452', 'Department 15', 'pic 15', '09123456789', 'maker15@gmail.com', '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(16, 'maker 16', 1, 'note 16', 1, '日本', '111-8727', 24, 'city 16', 'street 16', 'building 16', '18234453', 'Department 16', 'pic 16', '09123456789', 'maker16@gmail.com', '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(17, 'maker 17', 1, 'note 17', 1, 'その他', '111-8728', 48, 'city 17', 'street 17', 'building 17', '18234454', 'Department 17', 'pic 17', '09122324113', 'maker17@gmail.com', '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(18, 'maker 18', 1, 'note 18', 1, 'その他', '111-8729', 48, 'city 18', 'street 18', 'building 18', '18234455', 'Department 18', 'pic 18', '09123456789', 'maker18@gmail.com', '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(19, 'maker 19', 1, 'note 19', 1, 'その他', '111-8730', 48, 'city 19', 'street 19', 'building 19', '18234456', 'Department 19', 'pic 19', '09789435253', 'maker19@gmail.com', '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(20, 'maker 20', 1, 'note 20', 1, 'その他', '111-8731', 48, 'city 20', 'street 20', 'building 20', '12345697', 'Department 20', 'pic 20', '09578783453', 'maker20@gmail.com', '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(21, 'Maker 21', 1, NULL, 1, '日本', '212-0980', 2, 'City 21', 'Street 21', 'Building 21', '18001990', 'Department 21', 'Pic 21', '09876152437', 'maker21@gmail.com', '2023-02-23 13:49:25', NULL, '2023-02-23 13:49:25', NULL, '2023-02-23 15:07:03', NULL, 1),
(22, 'Maker 22', 1, NULL, 1, 'その他', '666-7777', 48, 'City 22', 'Street 22', 'Building 22', '18009121', 'Department 22', 'Pic 22', '09876271835', 'maker22@gmail.com', '2023-02-23 13:52:04', NULL, '2023-02-23 13:52:04', NULL, NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `m_operation`
--

CREATE TABLE `m_operation` (
  `operation_id` int NOT NULL COMMENT 'オペレーションID',
  `operation_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'オペレーション名',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `m_order`
--

CREATE TABLE `m_order` (
  `order_id` int NOT NULL,
  `company_order` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_order` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description_order` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'created_at',
  `created_by` int DEFAULT NULL COMMENT 'created_by',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'modified_at',
  `modified_by` int DEFAULT NULL COMMENT 'modified_by',
  `deleted_at` datetime DEFAULT NULL COMMENT 'deleted_at',
  `deleted_by` int DEFAULT NULL COMMENT 'deleted_by',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'is_deleted'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `m_order`
--

INSERT INTO `m_order` (`order_id`, `company_order`, `address_order`, `description_order`, `created_at`, `created_by`, `modified_at`, `modified_by`, `deleted_at`, `deleted_by`, `is_deleted`) VALUES
(1, 'Vhec1', 'Can Tho1', 'note1', '2023-06-07 12:45:35', NULL, '2023-06-07 13:42:33', NULL, '2023-06-07 19:21:48', NULL, 1),
(2, 'Vhec2', 'Can Tho2', 'note2', '2023-06-07 12:55:45', NULL, '2023-06-07 13:43:05', NULL, NULL, NULL, 0),
(3, 'Vhec3', 'Can Tho3', 'note3', '2023-06-07 12:58:40', NULL, '2023-06-07 14:52:41', NULL, NULL, NULL, 0),
(4, 'Vhec4', 'Can Tho4', 'note4', '2023-06-07 13:00:21', NULL, '2023-06-07 14:56:18', NULL, NULL, NULL, 0),
(5, NULL, NULL, NULL, '2023-06-07 13:02:28', NULL, '2023-06-07 13:02:28', NULL, NULL, NULL, 0),
(6, NULL, NULL, NULL, '2023-06-07 13:04:02', NULL, '2023-06-07 13:04:02', NULL, NULL, NULL, 0),
(7, NULL, NULL, NULL, '2023-06-07 13:05:58', NULL, '2023-06-07 13:05:58', NULL, NULL, NULL, 0),
(8, 'Vhec', 'Can Tho', 'note', '2023-06-07 13:07:14', NULL, '2023-06-07 13:07:14', NULL, NULL, NULL, 0),
(9, 'Vhec9', 'Can Tho9', 'note9', '2023-06-07 14:52:21', NULL, '2023-06-07 14:52:21', NULL, NULL, NULL, 0),
(10, NULL, NULL, NULL, '2023-06-07 19:08:25', NULL, '2023-06-07 19:08:25', NULL, NULL, NULL, 0),
(11, NULL, NULL, NULL, '2023-06-07 19:09:30', NULL, '2023-06-07 19:09:30', NULL, NULL, NULL, 0),
(12, NULL, NULL, NULL, '2023-06-07 19:11:07', NULL, '2023-06-07 19:11:07', NULL, NULL, NULL, 0),
(13, NULL, NULL, NULL, '2023-06-07 19:13:06', NULL, '2023-06-07 19:13:06', NULL, NULL, NULL, 0),
(14, NULL, NULL, NULL, '2023-06-07 19:13:51', NULL, '2023-06-07 19:13:51', NULL, NULL, NULL, 0),
(15, 'Vhec4', 'Can Tho4', 'note4', '2023-06-07 19:15:22', NULL, '2023-06-07 19:15:22', NULL, NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `m_order_detail`
--

CREATE TABLE `m_order_detail` (
  `order_detail_id` int NOT NULL COMMENT 'order_detail_id',
  `order_id` int DEFAULT NULL COMMENT 'order_id',
  `description_order_detail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'description_order_detail',
  `status_order_detail` int NOT NULL DEFAULT '0' COMMENT 'status_order_detail',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'created_at',
  `created_by` int DEFAULT NULL COMMENT 'created_by',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'modified_at',
  `modified_by` int DEFAULT NULL COMMENT 'modified_by',
  `deleted_at` datetime DEFAULT NULL COMMENT 'deleted_at',
  `deleted_by` int DEFAULT NULL COMMENT 'deleted_by',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'is_deleted'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `m_order_detail`
--

INSERT INTO `m_order_detail` (`order_detail_id`, `order_id`, `description_order_detail`, `status_order_detail`, `created_at`, `created_by`, `modified_at`, `modified_by`, `deleted_at`, `deleted_by`, `is_deleted`) VALUES
(1, 1, 'note', 0, '2023-06-07 16:16:07', NULL, '2023-06-07 16:20:08', NULL, '2023-06-07 19:21:48', NULL, 0),
(2, 1, 'note2', 0, '2023-06-07 16:30:38', NULL, '2023-06-07 16:30:56', NULL, '2023-06-07 19:21:48', NULL, 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `m_outsourcing_company`
--

CREATE TABLE `m_outsourcing_company` (
  `outsourcing_company_id` int NOT NULL COMMENT '委託先ID',
  `outsourcing_company_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '委託先名称',
  `area` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'エリア:hokkaido：北海道, tohoku：東北, kanto_koushinetsu：関東甲信, hokuriku：北陸, tokai：東海,kinki：近畿,chugoku：中国,shikoku：四国,kyushu：九州,okinawa：沖縄',
  `zip_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '郵便番号',
  `pref_code` int NOT NULL COMMENT '都道府県コード',
  `city` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '市区町村',
  `street` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '番地',
  `building` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '建物',
  `pilot_number` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '代表電話番号',
  `department` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '担当部署',
  `pic` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '担当者',
  `direct_number` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '担当電話番号',
  `direct_email_address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '担当メールアドレス',
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '備考',
  `sort_order` int NOT NULL DEFAULT '1' COMMENT '表示順',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `m_outsourcing_company`
--

INSERT INTO `m_outsourcing_company` (`outsourcing_company_id`, `outsourcing_company_name`, `area`, `zip_code`, `pref_code`, `city`, `street`, `building`, `pilot_number`, `department`, `pic`, `direct_number`, `direct_email_address`, `note`, `sort_order`, `version`, `created_at`, `created_by`, `modified_at`, `modified_by`, `deleted_at`, `deleted_by`, `is_deleted`) VALUES
(1, 'outsourcing company 1', '日本', '111-4321', 4, 'city 1', 'street 1', 'building 1', '12345678', 'Department 1', 'pic 1', '09123456789', 'outsourcingcompany1@gmail.com', 'note 1', 1, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(2, 'outsourcing company 2', '日本', '111-4322', 9, 'city 2', 'street 2', 'building 2', '18312679', 'Department 2', 'pic 2', '09122343432', 'outsourcingcompany2@gmail.com', 'note 2', 1, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(3, 'outsourcing company 3', '日本', '111-4323', 32, 'city 3', 'street 3', 'building 3', '18312680', 'Department 3', 'pic 3', '09167865332', 'outsourcingcompany3@gmail.com', 'note 3', 1, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(4, 'outsourcing company 4', '日本', '111-4324', 34, 'city 4', 'street 4', 'building 4', '18312681', 'Department 4', 'pic 4', '09123464563', 'outsourcingcompany4@gmail.com', 'note 4', 1, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(5, 'outsourcing company 5', '日本', '111-4325', 12, 'city 5', 'street 5', 'building 5', '18312682', 'Department 5', 'pic 5', '09123456789', 'outsourcingcompany5@gmail.com', 'note 5', 1, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(6, 'outsourcing company 6', '日本', '111-4326', 22, 'city 6', 'street 6', 'building 6', '18345679', 'Department 6', 'pic 6', '09123456789', 'outsourcingcompany6@gmail.com', 'note 6', 1, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(7, 'outsourcing company 7', 'その他', '111-4327', 48, 'city 7', 'street 7', 'building 7', '18345680', 'Department 7', 'pic 7', '09122343432', 'outsourcingcompany7@gmail.com', 'note 7', 1, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(8, 'outsourcing company 8', 'その他', '111-4328', 48, 'city 8', 'street 8', 'building 8', '18345681', 'Department 8', 'pic 8', '09167865332', 'outsourcingcompany8@gmail.com', 'note 8', 1, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(9, 'outsourcing company 9', 'その他', '111-4329', 48, 'city 9', 'street 9', 'building 9', '18345682', 'Department 9', 'pic 9', '09123464563', 'outsourcingcompany9@gmail.com', 'note 9', 1, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, '2023-02-23 15:07:15', NULL, 1),
(10, 'outsourcing company 10', 'その他', '111-4330', 48, 'city 10', 'street 10', 'building 10', '18345683', 'Department 10', 'pic 10', '09122343432', 'outsourcingcompany10@gmail.com', 'note 10', 1, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(11, 'outsourcing company 11', 'その他', '111-4331', 48, 'city 11', 'street 11', 'building 11', '18345684', 'Department 11', 'pic 11', '09167865332', 'outsourcingcompany11@gmail.com', 'note 11', 1, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(12, 'outsourcing company 12', '日本', '111-4332', 33, 'city 12', 'street 12', 'building 12', '18234449', 'Department 12', 'pic 12', '09123464563', 'outsourcingcompany12@gmail.com', 'note 12', 1, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(13, 'outsourcing company 13', '日本', '111-4333', 35, 'city 13', 'street 13', 'building 13', '18234450', 'Department 13', 'pic 13', '09122343432', 'outsourcingcompany13@gmail.com', 'note 13', 1, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(14, 'outsourcing company 14', '日本', '111-4334', 13, 'city 14', 'street 14', 'building 14', '18234451', 'Department 14', 'pic 14', '09123456789', 'outsourcingcompany14@gmail.com', 'note 14', 1, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(15, 'outsourcing company 15', '日本', '111-4335', 23, 'city 15', 'street 15', 'building 15', '18234452', 'Department 15', 'pic 15', '09123456789', 'outsourcingcompany15@gmail.com', 'note 15', 1, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(16, 'outsourcing company 16', '日本', '111-4336', 24, 'city 16', 'street 16', 'building 16', '18234453', 'Department 16', 'pic 16', '09123456789', 'outsourcingcompany16@gmail.com', 'note 16', 1, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(17, 'outsourcing company 17', 'その他', '111-4337', 48, 'city 17', 'street 17', 'building 17', '18234454', 'Department 17', 'pic 17', '09122324113', 'outsourcingcompany17@gmail.com', 'note 17', 1, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(18, 'outsourcing company 18', 'その他', '111-4338', 48, 'city 18', 'street 18', 'building 18', '18234455', 'Department 18', 'pic 18', '09123456789', 'outsourcingcompany18@gmail.com', 'note 18', 1, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(19, 'outsourcing company 19', 'その他', '111-4339', 48, 'city 19', 'street 19', 'building 19', '18234456', 'Department 19', 'pic 19', '09789435253', 'outsourcingcompany19@gmail.com', 'note 19', 1, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(20, 'outsourcing company 20', 'その他', '111-4340', 48, 'city 20', 'street 20', 'building 20', '12345697', 'Department 20', 'pic 20', '09578783453', 'outsourcingcompany20@gmail.com', 'note 20', 1, 1, '2023-02-01 19:52:38', NULL, '2023-02-01 19:52:38', NULL, NULL, NULL, 0),
(21, 'Outsourcing company 21', '日本', '222-1111', 46, 'City 22', 'Street 21', 'Building 21', '18001919', 'Department 21', 'Pic 21', '09876152431', 'outsourcingcompany21@gmail.com', NULL, 1, 1, '2023-02-23 15:05:06', NULL, '2023-02-23 15:05:06', NULL, NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `m_prefecture`
--

CREATE TABLE `m_prefecture` (
  `pref_id` int NOT NULL COMMENT '県ID',
  `pref_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '名前県'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `m_prefecture`
--

INSERT INTO `m_prefecture` (`pref_id`, `pref_name`) VALUES
(1, '愛知県'),
(2, '秋田県'),
(3, '青森県'),
(4, '千葉県'),
(5, '愛媛県'),
(6, '福井県'),
(7, '福岡県'),
(8, '福島県'),
(9, '岐阜県'),
(10, '群馬県'),
(11, '広島県'),
(12, '北海道'),
(13, '兵庫県'),
(14, '茨城県'),
(15, '石川県'),
(16, '岩手県'),
(17, '香川県'),
(18, '鹿児島県'),
(19, '神奈川県'),
(20, '高知県'),
(21, '熊本県'),
(22, '京都府'),
(23, '三重県'),
(24, '宮城県'),
(25, '宮崎県'),
(26, '長野県'),
(27, '長崎県'),
(28, '奈良県'),
(29, '新潟県'),
(30, '大分県'),
(31, '岡山県'),
(32, '沖縄県'),
(33, '大阪府'),
(34, '佐賀県'),
(35, '埼玉県'),
(36, '滋賀県'),
(37, '島根県'),
(38, '静岡県'),
(39, '栃木県'),
(40, '徳島県'),
(41, '東京都'),
(42, '鳥取県'),
(43, '富山県'),
(44, '和歌山県'),
(45, '山形県'),
(46, '山口県'),
(47, '山梨県'),
(48, 'その他');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `m_role`
--

CREATE TABLE `m_role` (
  `role_id` int NOT NULL COMMENT 'ロールID',
  `role_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ロール名',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `m_role_operation`
--

CREATE TABLE `m_role_operation` (
  `role_id` int NOT NULL COMMENT 'ロールID',
  `operation_id` int DEFAULT NULL COMMENT 'オペレーションID',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `m_supplier`
--

CREATE TABLE `m_supplier` (
  `supplier_id` int NOT NULL COMMENT '発注先ID',
  `supplier_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '発注先名称',
  `zip_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '郵便番号',
  `pref_code` int NOT NULL COMMENT '都道府県コード',
  `city` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '市区町村',
  `street` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '番地',
  `building` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '建物',
  `pilot_number` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '代表電話番号',
  `department` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '担当部署',
  `pic` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '担当者',
  `direct_number` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '担当電話番号',
  `direct_email_address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '担当メールアドレス',
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '備考',
  `sort_order` int NOT NULL DEFAULT '1' COMMENT '表示順',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `t_arrival`
--

CREATE TABLE `t_arrival` (
  `arrival_id` int NOT NULL COMMENT '資産ID:資産登録前だが資産IDとする',
  `arrival_code` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '資産コード',
  `is_asset` tinyint(1) NOT NULL DEFAULT '0' COMMENT '資産登録フラグ:0：未、1：済',
  `inspection_status` int NOT NULL DEFAULT '0' COMMENT '検品ステータス:0：未,1：合格,2：不合格',
  `inspection_status_note` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '検査ステータスノート',
  `inspection_date` date DEFAULT NULL COMMENT '検査日',
  `inspection_account_id` int DEFAULT NULL COMMENT '検品担当者',
  `asset_approve_account_id` int DEFAULT NULL,
  `failure_action` int NOT NULL DEFAULT '0' COMMENT '不合格処理:0：未,1：返品(再入荷待ち),2：返品(再入荷済),3：返品(再入荷なし)',
  `failure_action_note` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '障害アクションノート',
  `order_id` int DEFAULT NULL COMMENT '発注明細ID',
  `item_id` int DEFAULT NULL COMMENT '品目ID',
  `item_name_kana` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '品目名称カナ',
  `item_type_id` int DEFAULT NULL COMMENT 'タイプID',
  `price` int DEFAULT NULL COMMENT '単価',
  `base_id` int DEFAULT NULL COMMENT '入荷拠点ID',
  `arrival_type` int NOT NULL DEFAULT '0' COMMENT '入荷方法:0：発注,1：持ち込み',
  `arrival_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '入荷日',
  `record_type` int NOT NULL DEFAULT '0' COMMENT '計上方式',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済',
  `account_id` int DEFAULT NULL COMMENT 'アカウントID',
  `using_from` date DEFAULT NULL,
  `using_to` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `t_arrival`
--

INSERT INTO `t_arrival` (`arrival_id`, `arrival_code`, `is_asset`, `inspection_status`, `inspection_status_note`, `inspection_date`, `inspection_account_id`, `asset_approve_account_id`, `failure_action`, `failure_action_note`, `order_id`, `item_id`, `item_name_kana`, `item_type_id`, `price`, `base_id`, `arrival_type`, `arrival_on`, `record_type`, `created_at`, `created_by`, `modified_at`, `modified_by`, `deleted_at`, `deleted_by`, `is_deleted`, `account_id`, `using_from`, `using_to`) VALUES
(1, NULL, 0, 0, NULL, NULL, 1, 1, 0, NULL, 3, 19, NULL, 1, NULL, 1, 0, '2023-06-08 19:09:54', 0, '2023-06-08 19:09:54', NULL, '2023-06-08 19:09:54', NULL, NULL, NULL, 0, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `t_asset`
--

CREATE TABLE `t_asset` (
  `asset_id` int NOT NULL COMMENT '資産ID',
  `asset_name_kana` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '資産名称カナ',
  `asset_cd` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '資産コード',
  `asset_status` int NOT NULL DEFAULT '0' COMMENT '資産ステータス:0：在庫(stock), 1：キッティング中(kitting), 2：出荷中(shipping), 3：集荷中(pickingup), 4：修理中(repairing), 5：廃棄中(disposing), 6：利用中(using), 7：廃棄済み(disposed)',
  `asset_kind` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '資産種別:set_desktop：デスクトップセット,set_laptop：ノートセット,desktop：デスクトップ,laptop：ノート,tablet：タブレット,device：機器,software_without_license：ソフトウェア(ライセンスなし),software_with_license：ソフトウェア(ライセンスあり),cloud_license：クラウドライセンス',
  `asset_type` int NOT NULL DEFAULT '0' COMMENT '資産区分:0：一般、1：ライセンス',
  `asset_from` date DEFAULT NULL COMMENT '資産開始日',
  `asset_to` date DEFAULT NULL COMMENT '資産終了日',
  `parent_asset_id` int DEFAULT NULL COMMENT '親資産ID',
  `record_type` int NOT NULL DEFAULT '0' COMMENT '計上方式',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済',
  `arrival_id` int NOT NULL COMMENT '資産ID',
  `account_id` int DEFAULT NULL COMMENT '資産ID',
  `using_from` date DEFAULT NULL,
  `using_to` date DEFAULT NULL,
  `kitting_master_id` int DEFAULT NULL COMMENT 'キッティングマスタID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `t_asset`
--

INSERT INTO `t_asset` (`asset_id`, `asset_name_kana`, `asset_cd`, `asset_status`, `asset_kind`, `asset_type`, `asset_from`, `asset_to`, `parent_asset_id`, `record_type`, `version`, `created_at`, `created_by`, `modified_at`, `modified_by`, `deleted_at`, `deleted_by`, `is_deleted`, `arrival_id`, `account_id`, `using_from`, `using_to`, `kitting_master_id`) VALUES
(1, 'Computer mouse', NULL, 6, NULL, 0, NULL, NULL, NULL, 0, 1, '2023-02-21 15:54:29', NULL, '2023-02-21 15:54:29', NULL, NULL, NULL, 0, 1, 1, NULL, NULL, NULL),
(2, 'CPU', NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 1, '2023-02-21 15:54:42', NULL, '2023-02-21 15:54:42', NULL, NULL, NULL, 0, 1, 1, NULL, NULL, NULL),
(3, 'RAM', NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 1, '2023-02-21 15:54:53', NULL, '2023-02-21 15:54:53', NULL, NULL, NULL, 0, 1, 1, NULL, NULL, NULL),
(4, 'Computer mouse', NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 1, '2023-02-21 15:55:05', NULL, '2023-02-21 15:55:05', NULL, NULL, NULL, 0, 1, 1, NULL, NULL, NULL),
(5, 'CPU', NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 1, '2023-02-21 15:55:19', NULL, '2023-02-21 15:55:19', NULL, NULL, NULL, 0, 1, 1, NULL, NULL, NULL),
(6, 'CPU', NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 1, '2023-02-21 15:56:35', NULL, '2023-02-21 15:56:35', NULL, NULL, NULL, 0, 1, 1, NULL, NULL, NULL),
(7, 'Network card', NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 1, '2023-02-21 15:56:44', NULL, '2023-02-21 15:56:44', NULL, NULL, NULL, 0, 1, 1, NULL, NULL, NULL),
(8, 'Keyboard', NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 1, '2023-02-21 15:59:15', NULL, '2023-02-21 15:59:15', NULL, NULL, NULL, 0, 1, 1, NULL, NULL, NULL),
(9, 'Screen', NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 1, '2023-02-21 16:00:10', NULL, '2023-02-21 16:00:10', NULL, NULL, NULL, 0, 1, 1, NULL, NULL, NULL),
(10, 'Software 1', NULL, 0, NULL, 1, NULL, NULL, NULL, 0, 1, '2023-02-21 16:02:24', NULL, '2023-02-21 16:02:24', NULL, NULL, NULL, 0, 1, 1, NULL, NULL, NULL),
(11, 'Screen', NULL, 2, NULL, 0, NULL, NULL, NULL, 0, 1, '2023-02-21 16:14:01', NULL, '2023-02-21 16:14:01', NULL, NULL, NULL, 0, 1, 1, NULL, NULL, NULL),
(12, 'Computer mouse', NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 1, '2023-02-21 16:14:21', NULL, '2023-02-21 16:14:21', NULL, NULL, NULL, 0, 1, 1, NULL, NULL, NULL),
(13, 'Keyboard', NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 1, '2023-02-21 16:14:31', NULL, '2023-02-21 16:14:31', NULL, NULL, NULL, 0, 1, 1, NULL, NULL, NULL),
(14, 'Software 5', NULL, 0, NULL, 1, NULL, NULL, NULL, 0, 1, '2023-02-23 11:22:18', NULL, '2023-02-23 11:22:18', NULL, NULL, NULL, 0, 1, 1, '2023-02-16', '2023-02-25', NULL),
(16, 'RAM', NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 1, '2023-02-23 16:02:33', NULL, '2023-02-23 16:02:33', NULL, NULL, NULL, 0, 1, 2, '2023-02-04', '2023-02-09', NULL),
(17, 'Network card', NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 1, '2023-02-23 16:04:18', NULL, '2023-02-23 16:04:18', NULL, NULL, NULL, 0, 1, 2, '2023-02-04', '2023-02-09', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `t_asset_depreciation`
--

CREATE TABLE `t_asset_depreciation` (
  `asset_depreciation_id` int NOT NULL,
  `asset_id` int DEFAULT NULL COMMENT '資産ID',
  `depreciation_rule_id` int DEFAULT NULL,
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `t_asset_set`
--

CREATE TABLE `t_asset_set` (
  `asset_id_set` int NOT NULL,
  `asset_set_type` int NOT NULL DEFAULT '0',
  `asset_set_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `asset_set_jan_code` varchar(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `asset_set_maker_id` int NOT NULL,
  `asset_set_maker_model` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `asset_set_os` int NOT NULL DEFAULT '0',
  `asset_set_expiration_date_from` date DEFAULT NULL,
  `asset_set_expiration_date_to` date DEFAULT NULL,
  `tax_inc_price` float DEFAULT NULL COMMENT '税には価格が含まれます',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済',
  `order_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `t_asset_set`
--

INSERT INTO `t_asset_set` (`asset_id_set`, `asset_set_type`, `asset_set_name`, `asset_set_jan_code`, `asset_set_maker_id`, `asset_set_maker_model`, `asset_set_os`, `asset_set_expiration_date_from`, `asset_set_expiration_date_to`, `tax_inc_price`, `created_at`, `created_by`, `modified_at`, `modified_by`, `deleted_at`, `deleted_by`, `is_deleted`, `order_id`) VALUES
(1, 0, 'item set 1', 'code 1', 9, 'model 1', 0, '2023-02-17', '2023-02-21', NULL, '2023-02-21 15:55:05', NULL, '2023-02-21 15:55:05', NULL, NULL, NULL, 0, 9),
(2, 0, 'item set 2', 'code 2', 12, 'model 2', 1, '2023-02-22', '2023-02-27', NULL, '2023-02-21 16:02:24', NULL, '2023-02-21 16:02:24', NULL, NULL, NULL, 0, 13),
(3, 0, 'item set 1', 'code 1', 9, 'model 1', 0, '2023-02-17', '2023-02-21', NULL, '2023-02-21 16:14:02', NULL, '2023-02-21 16:14:02', NULL, NULL, NULL, 0, 28),
(4, 0, 'item set 2', 'code 2', 12, 'model 2', 1, '2023-02-22', '2023-02-27', NULL, '2023-02-23 11:22:19', NULL, '2023-02-23 11:22:19', NULL, NULL, NULL, 0, 29),
(5, 0, 'item set 3', 'code 3', 16, 'model 3', 0, '2023-02-04', '2023-02-28', NULL, '2023-02-23 16:02:33', NULL, '2023-02-23 16:02:33', NULL, NULL, NULL, 0, 23),
(6, 0, 'item set 5', 'code 5', 14, 'model 5', 0, '2023-02-24', '2023-02-28', NULL, '2023-02-23 16:04:18', NULL, '2023-02-23 16:04:18', NULL, NULL, NULL, 0, 14);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `t_asset_set_asset`
--

CREATE TABLE `t_asset_set_asset` (
  `asset_set_asset_id` int NOT NULL,
  `asset_id_set` int NOT NULL,
  `asset_id` int DEFAULT NULL COMMENT '資産ID',
  `is_main` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'メインフラグ:0：非メイン、1：メイン品目。「メイン可」の品目タイプの品目が対象',
  `sort_order` int NOT NULL DEFAULT '1' COMMENT '表示順',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `t_asset_set_asset`
--

INSERT INTO `t_asset_set_asset` (`asset_set_asset_id`, `asset_id_set`, `asset_id`, `is_main`, `sort_order`, `version`, `created_at`, `created_by`, `modified_at`, `modified_by`, `deleted_at`, `deleted_by`, `is_deleted`) VALUES
(1, 1, 4, 0, 1, 1, '2023-02-21 00:00:00', NULL, '2023-02-21 00:00:00', NULL, NULL, NULL, 0),
(2, 1, 6, 0, 1, 1, '2023-02-21 00:00:00', NULL, '2023-02-21 00:00:00', NULL, NULL, NULL, 0),
(3, 1, 8, 0, 1, 1, '2023-02-21 00:00:00', NULL, '2023-02-21 00:00:00', NULL, NULL, NULL, 0),
(4, 1, 9, 1, 1, 1, '2023-02-21 00:00:00', NULL, '2023-02-21 00:00:00', NULL, NULL, NULL, 0),
(5, 2, 10, 1, 1, 1, '2023-02-21 00:00:00', NULL, '2023-02-21 00:00:00', NULL, NULL, NULL, 0),
(6, 3, 11, 1, 1, 1, '2023-02-21 00:00:00', NULL, '2023-02-21 00:00:00', NULL, NULL, NULL, 0),
(7, 3, 12, 0, 1, 1, '2023-02-21 00:00:00', NULL, '2023-02-21 00:00:00', NULL, NULL, NULL, 0),
(8, 3, 13, 0, 1, 1, '2023-02-21 00:00:00', NULL, '2023-02-21 00:00:00', NULL, NULL, NULL, 0),
(9, 4, 14, 0, 1, 1, '2023-02-21 00:00:00', NULL, '2023-02-21 00:00:00', NULL, NULL, NULL, 0),
(10, 5, 16, 1, 1, 1, '2023-02-21 00:00:00', NULL, '2023-02-21 00:00:00', NULL, NULL, NULL, 0),
(11, 6, 17, 1, 1, 1, '2023-02-21 00:00:00', NULL, '2023-02-21 00:00:00', NULL, NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `t_disposal`
--

CREATE TABLE `t_disposal` (
  `disposal_id` int NOT NULL COMMENT '廃棄ID',
  `disposal_status` int NOT NULL DEFAULT '0' COMMENT '廃棄ステータス: 0：未, 1：中, 2：完了',
  `asset_id` int DEFAULT NULL COMMENT '資産ID',
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '備考',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済',
  `outsourcing_company_id` int DEFAULT NULL COMMENT '委託先ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `t_disposal`
--

INSERT INTO `t_disposal` (`disposal_id`, `disposal_status`, `asset_id`, `note`, `version`, `created_at`, `created_by`, `modified_at`, `modified_by`, `deleted_at`, `deleted_by`, `is_deleted`, `outsourcing_company_id`) VALUES
(1, 0, 1, 'aaaa', 1, '2023-02-22 13:52:29', 1, '2023-02-24 13:52:29', 1, '2023-02-23 13:52:29', 1, 0, 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `t_kitting`
--

CREATE TABLE `t_kitting` (
  `kitting_id` int NOT NULL COMMENT 'キットID',
  `kitting_status` int NOT NULL DEFAULT '0' COMMENT 'キッティングステータス: 0：未, 1：中, 2：完了',
  `asset_id` int DEFAULT NULL COMMENT '資産ID',
  `kitting_user_id` int DEFAULT NULL COMMENT 'アカウントID',
  `account_id` int DEFAULT NULL COMMENT 'アカウントID',
  `kitting_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済',
  `hardware_confirm_account_id` int DEFAULT NULL,
  `software_confirm_account_id` int DEFAULT NULL,
  `kitting_confirm_account_id` int DEFAULT NULL,
  `functional_confirm_account_id` int DEFAULT NULL,
  `kitting_comment` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `t_kitting`
--

INSERT INTO `t_kitting` (`kitting_id`, `kitting_status`, `asset_id`, `kitting_user_id`, `account_id`, `kitting_at`, `completed_at`, `version`, `created_at`, `created_by`, `modified_at`, `modified_by`, `deleted_at`, `deleted_by`, `is_deleted`, `hardware_confirm_account_id`, `software_confirm_account_id`, `kitting_confirm_account_id`, `functional_confirm_account_id`, `kitting_comment`) VALUES
(1, 0, 1, 1, 1, '2023-02-22 13:44:47', '2023-02-16 13:44:47', 1, '2023-02-25 15:45:26', 1, '2023-02-25 16:04:23', 1, '2023-02-17 13:44:47', 1, 0, 1, 1, 1, 1, 'aaaaaaa');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `t_message`
--

CREATE TABLE `t_message` (
  `message_id` int NOT NULL COMMENT 'メッセージID',
  `asset_id` int DEFAULT NULL COMMENT '資産ID',
  `account_id` int DEFAULT NULL COMMENT 'アカウントID',
  `group_id` int DEFAULT NULL COMMENT 'グループID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'タイトル',
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'メッセージ',
  `created_datetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '発信日',
  `created_account_id` int DEFAULT NULL COMMENT '送付者ID',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `t_notification`
--

CREATE TABLE `t_notification` (
  `notification_id` int NOT NULL COMMENT '通知ID',
  `notification_cd` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '通知コード:yyyymmdd0000 通知日時＋連番',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '件名',
  `body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '内容',
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '備考',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `t_notification_to`
--

CREATE TABLE `t_notification_to` (
  `notification_id` int NOT NULL COMMENT '通知先ID:自動採番',
  `notification_to_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '通知先区分:0：アカウント、1：グループ、2：ベース',
  `account_id` int DEFAULT NULL COMMENT 'アカウントID',
  `group_id` int DEFAULT NULL COMMENT 'グループID',
  `base_id` int DEFAULT NULL COMMENT '拠点ID',
  `notification_status` int NOT NULL DEFAULT '0' COMMENT '通知ステータス:temporarily',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `t_order`
--

CREATE TABLE `t_order` (
  `order_id` int NOT NULL COMMENT '発注明細ID:自動採番',
  `procurement_id` int NOT NULL COMMENT '調達ID',
  `item_id` int DEFAULT NULL COMMENT '品目ID',
  `quantity` int DEFAULT NULL COMMENT '数量',
  `amount` float DEFAULT NULL COMMENT '小計',
  `has_users_file` int NOT NULL DEFAULT '0' COMMENT '利用者ファイル有無:0：なし、1：あり実ファイルはS3の以下に格納。バケット名/{調達ID}/{発注明細ID}+"_users_"+[アップロードした時のファイル名]',
  `has_quotation_file` int NOT NULL DEFAULT '0' COMMENT '見積有無:0：なし、1：あり実ファイルはS3の以下に格納。バケット名/{調達ID}/{発注明細ID}+"_quotation_"+[アップロードした時のファイル名]：',
  `estimated_arrival_date` date DEFAULT NULL COMMENT '入荷予定日',
  `estimated_shipping_date` date DEFAULT NULL COMMENT '出荷予定日',
  `record_type` int NOT NULL DEFAULT '0' COMMENT '計上方式',
  `supplier_id` int DEFAULT NULL COMMENT '発注先ID',
  `order_on` date DEFAULT NULL COMMENT '発注日',
  `has_order_file` int NOT NULL DEFAULT '0' COMMENT 'エビデンスファイル有無:0：なし、1：あり実ファイルはS3の以下に格納。バケット名/{調達ID}/{発注明細ID}+"_order_"+[アップロードした時のファイル名]',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済',
  `item_id_set` int DEFAULT NULL COMMENT 'セット用品目ID:セット用の品目の品目ID',
  `kitting_master_id` int DEFAULT NULL COMMENT 'キッティングマスタID',
  `depreciation_rule_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `t_order`
--

INSERT INTO `t_order` (`order_id`, `procurement_id`, `item_id`, `quantity`, `amount`, `has_users_file`, `has_quotation_file`, `estimated_arrival_date`, `estimated_shipping_date`, `record_type`, `supplier_id`, `order_on`, `has_order_file`, `version`, `created_at`, `created_by`, `modified_at`, `modified_by`, `deleted_at`, `deleted_by`, `is_deleted`, `item_id_set`, `kitting_master_id`, `depreciation_rule_id`) VALUES
(3, 1, 1, 3, 26400, 0, 0, NULL, NULL, 0, NULL, '2023-02-21', 0, 1, '2023-02-03 17:15:51', NULL, '2023-02-03 17:15:51', NULL, NULL, NULL, 0, NULL, 1, 1),
(4, 1, 3, 3, 448800, 0, 0, NULL, NULL, 0, NULL, '2023-02-21', 0, 1, '2023-02-03 17:15:51', NULL, '2023-02-03 17:15:51', NULL, NULL, NULL, 0, NULL, NULL, NULL),
(6, 2, 5, 2, 580800, 0, 0, NULL, NULL, 0, NULL, '2023-02-21', 0, 1, '2023-02-03 17:15:51', NULL, '2023-02-03 17:15:51', NULL, NULL, NULL, 0, NULL, NULL, NULL),
(9, 3, NULL, 2, 1337600, 0, 0, NULL, NULL, 0, NULL, '2023-02-21', 0, 1, '2023-02-21 15:42:37', NULL, '2023-02-21 15:42:37', NULL, NULL, NULL, 0, 1, NULL, NULL),
(10, 3, 6, 2, 721600, 0, 0, NULL, NULL, 0, NULL, '2023-02-21', 0, 1, '2023-02-03 17:15:51', NULL, '2023-02-03 17:15:51', NULL, NULL, NULL, 0, NULL, NULL, NULL),
(13, 4, NULL, 2, 9137600, 0, 0, NULL, NULL, 0, NULL, '2023-02-21', 0, 1, '2023-02-21 15:43:54', NULL, '2023-02-21 15:43:54', NULL, NULL, NULL, 0, 2, NULL, NULL),
(14, 4, NULL, 2, 1987200, 0, 0, NULL, NULL, 0, NULL, '2023-02-23', 0, 1, '2023-02-21 15:46:15', NULL, '2023-02-21 15:46:15', NULL, NULL, NULL, 0, 5, NULL, NULL),
(17, 5, 11, 1, 777600, 0, 0, NULL, NULL, 0, NULL, NULL, 0, 1, '2023-02-03 17:15:51', NULL, '2023-02-03 17:15:51', NULL, NULL, NULL, 0, NULL, NULL, NULL),
(18, 5, 18, 1, 1260400, 0, 0, NULL, NULL, 0, NULL, NULL, 0, 1, '2023-02-03 17:15:51', NULL, '2023-02-03 17:15:51', NULL, NULL, NULL, 0, NULL, NULL, NULL),
(22, 6, 14, 1, 966000, 0, 0, NULL, NULL, 0, NULL, NULL, 0, 1, '2023-02-03 17:15:51', NULL, '2023-02-03 17:15:51', NULL, NULL, NULL, 0, NULL, NULL, NULL),
(23, 6, NULL, 2, 3230400, 0, 0, NULL, NULL, 0, NULL, '2023-02-23', 0, 1, '2023-02-21 15:44:37', NULL, '2023-02-21 15:44:37', NULL, NULL, NULL, 0, 3, NULL, NULL),
(24, 6, 2, 2, 158400, 0, 0, NULL, NULL, 0, NULL, NULL, 0, 1, '2023-02-03 17:15:51', NULL, '2023-02-03 17:15:51', NULL, NULL, NULL, 0, NULL, NULL, NULL),
(26, 7, NULL, 2, 1987200, 0, 0, NULL, NULL, 0, NULL, NULL, 0, 1, '2023-02-21 15:46:15', NULL, '2023-02-21 15:46:15', NULL, NULL, NULL, 0, 5, NULL, NULL),
(28, 8, NULL, 1, 668800, 0, 0, '2023-02-14', '2023-02-24', 0, NULL, '2023-02-21', 0, 1, '2023-02-21 15:42:37', NULL, '2023-02-21 15:42:37', NULL, NULL, NULL, 0, 1, NULL, NULL),
(29, 9, NULL, 1, 4568800, 0, 0, '2023-02-21', '2023-02-28', 0, NULL, '2023-02-23', 0, 1, '2023-02-21 15:43:54', NULL, '2023-02-21 15:43:54', NULL, NULL, NULL, 0, 2, NULL, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `t_pick_up`
--

CREATE TABLE `t_pick_up` (
  `pick_up_id` int NOT NULL COMMENT '集荷ID',
  `pick_up_status` int NOT NULL DEFAULT '0' COMMENT '集荷ステータス: 0：未, 1：中, 2：完了',
  `asset_id` int DEFAULT NULL COMMENT '資産ID',
  `pick_up_arrangement_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '集荷手配日',
  `pick_up_scheduled_date` date DEFAULT NULL COMMENT '集荷予定日',
  `completed_on` date DEFAULT NULL COMMENT '集荷完了日',
  `outsourcing_company_id` int DEFAULT NULL COMMENT '委託先ID',
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '備考',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済',
  `account_id` int DEFAULT NULL,
  `pick_up_type` int DEFAULT NULL COMMENT '集荷区分: 0:集荷待ち（返却）1:集荷待ち（修理）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `t_pick_up`
--

INSERT INTO `t_pick_up` (`pick_up_id`, `pick_up_status`, `asset_id`, `pick_up_arrangement_on`, `pick_up_scheduled_date`, `completed_on`, `outsourcing_company_id`, `note`, `version`, `created_at`, `created_by`, `modified_at`, `modified_by`, `deleted_at`, `deleted_by`, `is_deleted`, `account_id`, `pick_up_type`) VALUES
(1, 0, 1, '2023-02-25 15:51:45', '2023-02-08', '2023-02-16', 1, 'aaaaaaa', 1, '2023-02-25 15:51:45', 1, '2023-02-25 15:51:45', 1, '2023-02-22 13:51:18', 1, 0, 1, 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `t_procurement`
--

CREATE TABLE `t_procurement` (
  `procurement_id` int NOT NULL COMMENT '調達ID',
  `procurement_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '調達名称',
  `procurement_status` int NOT NULL DEFAULT '0' COMMENT '調達ステータス:0：作成中、1：見積依頼、2：見積回答、3：承認依頼、4：承認済、5：発注依頼、6：発注済、7：無効（削除）',
  `is_back` tinyint(1) NOT NULL DEFAULT '0' COMMENT '差戻フラグ:0：対象外、1：対象(差戻状態である)',
  `quotation_request_note` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '見積依頼備考',
  `quotation_request_datetime` datetime DEFAULT NULL COMMENT '見積依頼日時',
  `quotation_account_id` int DEFAULT NULL COMMENT '見積担当者',
  `quotation_note` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '見積回答備考',
  `quotation_datetime` datetime DEFAULT NULL COMMENT '見積回答日時',
  `approval_expiration_date` date DEFAULT NULL COMMENT '承認期限',
  `approval_request_note` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '承認依頼備考',
  `approval_request_datetime` datetime DEFAULT NULL COMMENT '承認依頼日時',
  `account_id` int DEFAULT NULL COMMENT '承認者',
  `approval_note` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '承認備考',
  `approval_datetime` datetime DEFAULT NULL COMMENT '承認日時',
  `ext_approval_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '外部承認ID',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済',
  `total_amount` bigint DEFAULT NULL,
  `quotation_requester` int DEFAULT NULL COMMENT '見積依頼者',
  `approval_requester` int DEFAULT NULL COMMENT '承認依頼者'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `t_procurement`
--

INSERT INTO `t_procurement` (`procurement_id`, `procurement_name`, `procurement_status`, `is_back`, `quotation_request_note`, `quotation_request_datetime`, `quotation_account_id`, `quotation_note`, `quotation_datetime`, `approval_expiration_date`, `approval_request_note`, `approval_request_datetime`, `account_id`, `approval_note`, `approval_datetime`, `ext_approval_id`, `version`, `created_at`, `created_by`, `modified_at`, `modified_by`, `deleted_at`, `deleted_by`, `is_deleted`, `total_amount`, `quotation_requester`, `approval_requester`) VALUES
(1, 'order 1', 6, 0, 'order 1', NULL, 1, NULL, '2023-02-15 00:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2023-02-21 15:47:51', NULL, '2023-02-21 15:47:51', NULL, NULL, NULL, 0, 475200, NULL, NULL),
(2, 'order 2', 6, 0, 'order 2', NULL, 1, NULL, '2023-02-21 00:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2023-02-21 15:48:37', NULL, '2023-02-21 15:48:37', NULL, NULL, NULL, 0, 580800, NULL, NULL),
(3, 'order 3', 6, 0, 'order 3', NULL, 1, NULL, '2023-02-10 00:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2023-02-21 15:49:57', NULL, '2023-02-21 15:49:57', NULL, NULL, NULL, 0, 2059200, NULL, NULL),
(4, 'order 4', 6, 0, 'order 4', NULL, 1, NULL, '2023-02-15 00:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2023-02-21 15:50:48', NULL, '2023-02-21 15:50:48', NULL, NULL, NULL, 0, 11124800, NULL, NULL),
(5, 'order 5', 5, 0, 'order 5', NULL, 1, NULL, '2023-02-16 00:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2023-02-21 15:52:04', NULL, '2023-02-21 15:52:04', NULL, NULL, NULL, 0, 2038000, NULL, NULL),
(6, 'order 6', 6, 0, 'order 6', NULL, 1, NULL, '2023-03-16 00:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2023-02-21 15:53:02', NULL, '2023-02-21 15:53:02', NULL, NULL, NULL, 0, 4354800, NULL, NULL),
(7, 'order 7', 5, 0, 'order 7', NULL, 1, NULL, '2023-02-22 00:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2023-02-21 16:03:31', NULL, '2023-02-21 16:03:31', NULL, NULL, NULL, 0, 1987200, NULL, NULL),
(8, 'order 8', 6, 0, 'order 8', NULL, 1, NULL, '2023-02-21 00:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2023-02-21 16:10:19', NULL, '2023-02-21 16:10:19', NULL, NULL, NULL, 0, 668800, NULL, NULL),
(9, 'order 9', 6, 0, 'order 9', NULL, 1, NULL, '2023-02-15 00:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2023-02-22 17:26:58', NULL, '2023-02-22 17:26:58', NULL, NULL, NULL, 0, 4568800, NULL, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `t_repairing`
--

CREATE TABLE `t_repairing` (
  `repairing_id` int NOT NULL COMMENT '修理ID',
  `repairing_status` int NOT NULL DEFAULT '0' COMMENT '修理ステータス: 0：未, 1：中, 2：完了',
  `asset_id` int DEFAULT NULL COMMENT '資産ID',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済',
  `outsourcing_company_id` int DEFAULT NULL COMMENT '委託先ID',
  `account_id` int DEFAULT NULL,
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `t_repairing`
--

INSERT INTO `t_repairing` (`repairing_id`, `repairing_status`, `asset_id`, `version`, `created_at`, `created_by`, `modified_at`, `modified_by`, `deleted_at`, `deleted_by`, `is_deleted`, `outsourcing_company_id`, `account_id`, `note`) VALUES
(1, 0, 1, 1, '2023-02-16 13:51:55', 1, '2023-02-16 13:51:55', 1, '2023-02-27 13:51:55', 1, 0, 1, 1, 'aaaaaa');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `t_shipping`
--

CREATE TABLE `t_shipping` (
  `shipping_id` int NOT NULL COMMENT '出荷ID',
  `shipping_reception_status` int NOT NULL DEFAULT '0' COMMENT '出荷受付ステータス',
  `shipping_status` int NOT NULL DEFAULT '0' COMMENT '出荷ステータス: 0：未, 1：中, 2：完了',
  `asset_id` int DEFAULT NULL COMMENT '資産ID',
  `reception_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '受付日',
  `working_on` date DEFAULT NULL COMMENT '作業開始日時',
  `completed_on` date DEFAULT NULL COMMENT '完了日時',
  `outsourcing_company_id` int DEFAULT NULL COMMENT '委託先ID',
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '備考',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済',
  `account_id` int DEFAULT NULL,
  `shipping_reception_type` int NOT NULL DEFAULT '0',
  `estimated_shipping_date` date DEFAULT NULL,
  `shipping_late` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `t_shipping`
--

INSERT INTO `t_shipping` (`shipping_id`, `shipping_reception_status`, `shipping_status`, `asset_id`, `reception_on`, `working_on`, `completed_on`, `outsourcing_company_id`, `note`, `version`, `created_at`, `created_by`, `modified_at`, `modified_by`, `deleted_at`, `deleted_by`, `is_deleted`, `account_id`, `shipping_reception_type`, `estimated_shipping_date`, `shipping_late`) VALUES
(1, 1, 1, 11, '2023-02-21 16:14:02', '2023-02-24', NULL, 2, NULL, 1, '2023-02-21 16:14:02', NULL, '2023-02-24 13:35:01', NULL, NULL, NULL, 0, 1, 0, '2023-02-24', 0),
(2, 0, 0, 12, '2023-02-21 16:14:21', NULL, NULL, NULL, NULL, 1, '2023-02-21 16:14:21', NULL, '2023-02-21 16:14:21', NULL, NULL, NULL, 0, 1, 0, '2023-02-24', 0),
(3, 0, 0, 13, '2023-02-21 16:14:31', NULL, NULL, NULL, NULL, 1, '2023-02-21 16:14:31', NULL, '2023-02-21 16:14:31', NULL, NULL, NULL, 0, 1, 0, '2023-02-24', 0),
(4, 0, 0, 14, '2023-02-23 11:22:19', NULL, NULL, NULL, NULL, 1, '2023-02-23 11:22:19', NULL, '2023-02-23 11:22:19', NULL, NULL, NULL, 0, 1, 0, '2023-02-28', 0),
(5, 0, 0, 16, '2023-02-23 16:02:33', NULL, NULL, NULL, NULL, 1, '2023-02-23 16:02:33', NULL, '2023-02-23 16:02:33', NULL, NULL, NULL, 0, 2, 0, NULL, 0),
(6, 0, 0, 17, '2023-02-23 16:04:18', NULL, NULL, NULL, NULL, 1, '2023-02-23 16:04:18', NULL, '2023-02-23 16:04:18', NULL, NULL, NULL, 0, 2, 0, NULL, 0),
(7, 1, 2, 1, '2023-02-23 18:15:21', '2022-01-01', '2023-02-24', 2, NULL, 1, '2023-02-23 18:15:21', NULL, '2023-02-24 13:32:44', NULL, NULL, NULL, 0, 1, 0, '2023-02-11', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `t_support`
--

CREATE TABLE `t_support` (
  `support_id` int NOT NULL COMMENT '問合せID',
  `asset_id` int DEFAULT NULL COMMENT '資産ID',
  `account_id` int DEFAULT NULL COMMENT 'アカウントID',
  `group_id` int DEFAULT NULL COMMENT 'グループID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'タイトル',
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '対応内容',
  `created_datetime` datetime DEFAULT NULL COMMENT '登録日',
  `created_account_id` int DEFAULT NULL COMMENT '登録者ID',
  `modified_datetime` datetime DEFAULT NULL COMMENT '更新日',
  `modified_account_id` int DEFAULT NULL COMMENT '更新者ID',
  `completion_from` datetime DEFAULT NULL COMMENT '完了日',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `t_use`
--

CREATE TABLE `t_use` (
  `use_id` int NOT NULL COMMENT '利用ID',
  `use_status` int NOT NULL DEFAULT '0' COMMENT '利用ステータス: 0：未, 1：中, 2：完了',
  `asset_id` int DEFAULT NULL COMMENT '資産ID',
  `use_on_from` date DEFAULT NULL COMMENT '利用開始日',
  `use_on_to` date DEFAULT NULL COMMENT '利用終了日',
  `account_id` int DEFAULT NULL COMMENT 'アカウントID',
  `group_id` int DEFAULT NULL COMMENT 'グループID',
  `base_id` int DEFAULT NULL COMMENT '拠点ID',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `t_user_request`
--

CREATE TABLE `t_user_request` (
  `request_id` int NOT NULL COMMENT '申請ID',
  `group_id` int DEFAULT NULL COMMENT 'グループID',
  `account_id` int DEFAULT NULL COMMENT 'アカウントID',
  `asset_id` int DEFAULT NULL COMMENT '資産ID',
  `request_menu` int DEFAULT NULL COMMENT '申請メニュー',
  `request_status` int DEFAULT NULL COMMENT '申請状況',
  `request_type` int DEFAULT NULL COMMENT '申請種類',
  `request_datetime` datetime DEFAULT NULL COMMENT '申請日',
  `request_account_id` int DEFAULT NULL COMMENT '申請者ID',
  `request_group_id` int DEFAULT NULL COMMENT '申請グループID',
  `substitute_asset_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '代替資産ID',
  `request_completion_date` datetime DEFAULT NULL COMMENT '対応完了希望日',
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '要望',
  `version` int NOT NULL DEFAULT '1' COMMENT 'バージョン:楽観的排他で利用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時:プログラムでは設定しない',
  `created_by` int DEFAULT NULL COMMENT '作成処理:プログラムで設定、API名、関数名',
  `modified_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時:プログラムでは設定しない',
  `modified_by` int DEFAULT NULL COMMENT '更新処理:プログラムで設定、API名、関数名',
  `deleted_by` int DEFAULT NULL COMMENT '削除者',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '登録旗deleted: 0：消去未 ,1：消去済'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `alembic_version`
--
ALTER TABLE `alembic_version`
  ADD PRIMARY KEY (`version_num`);

--
-- Chỉ mục cho bảng `m_account`
--
ALTER TABLE `m_account`
  ADD PRIMARY KEY (`account_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `modified_by` (`modified_by`);

--
-- Chỉ mục cho bảng `m_account_base`
--
ALTER TABLE `m_account_base`
  ADD PRIMARY KEY (`account_base_id`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `base_id` (`base_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `modified_by` (`modified_by`);

--
-- Chỉ mục cho bảng `m_account_group`
--
ALTER TABLE `m_account_group`
  ADD PRIMARY KEY (`account_group_id`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `group_id` (`group_id`),
  ADD KEY `modified_by` (`modified_by`);

--
-- Chỉ mục cho bảng `m_account_role`
--
ALTER TABLE `m_account_role`
  ADD PRIMARY KEY (`account_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `modified_by` (`modified_by`),
  ADD KEY `role_id` (`role_id`);

--
-- Chỉ mục cho bảng `m_base`
--
ALTER TABLE `m_base`
  ADD PRIMARY KEY (`base_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `modified_by` (`modified_by`),
  ADD KEY `pref_code` (`pref_code`);

--
-- Chỉ mục cho bảng `m_depreciation_rule`
--
ALTER TABLE `m_depreciation_rule`
  ADD PRIMARY KEY (`depreciation_rule_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `modified_by` (`modified_by`);

--
-- Chỉ mục cho bảng `m_gen_code`
--
ALTER TABLE `m_gen_code`
  ADD PRIMARY KEY (`gen_code_id`);

--
-- Chỉ mục cho bảng `m_group`
--
ALTER TABLE `m_group`
  ADD PRIMARY KEY (`group_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `modified_by` (`modified_by`);

--
-- Chỉ mục cho bảng `m_item`
--
ALTER TABLE `m_item`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `maker_id` (`maker_id`),
  ADD KEY `modified_by` (`modified_by`);

--
-- Chỉ mục cho bảng `m_item_set`
--
ALTER TABLE `m_item_set`
  ADD PRIMARY KEY (`item_id_set`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `item_set_maker_id` (`item_set_maker_id`),
  ADD KEY `modified_by` (`modified_by`);

--
-- Chỉ mục cho bảng `m_item_set_item`
--
ALTER TABLE `m_item_set_item`
  ADD PRIMARY KEY (`item_set_item_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `item_id` (`item_id`),
  ADD KEY `modified_by` (`modified_by`),
  ADD KEY `item_id_set` (`item_id_set`);

--
-- Chỉ mục cho bảng `m_item_type`
--
ALTER TABLE `m_item_type`
  ADD PRIMARY KEY (`item_type_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `modified_by` (`modified_by`);

--
-- Chỉ mục cho bảng `m_kitting`
--
ALTER TABLE `m_kitting`
  ADD PRIMARY KEY (`kitting_master_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `modified_by` (`modified_by`);

--
-- Chỉ mục cho bảng `m_maker`
--
ALTER TABLE `m_maker`
  ADD PRIMARY KEY (`maker_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `modified_by` (`modified_by`),
  ADD KEY `pref_code` (`pref_code`);

--
-- Chỉ mục cho bảng `m_operation`
--
ALTER TABLE `m_operation`
  ADD PRIMARY KEY (`operation_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `modified_by` (`modified_by`);

--
-- Chỉ mục cho bảng `m_order`
--
ALTER TABLE `m_order`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `modified_by` (`modified_by`);

--
-- Chỉ mục cho bảng `m_order_detail`
--
ALTER TABLE `m_order_detail`
  ADD PRIMARY KEY (`order_detail_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `modified_by` (`modified_by`),
  ADD KEY `order_id` (`order_id`);

--
-- Chỉ mục cho bảng `m_outsourcing_company`
--
ALTER TABLE `m_outsourcing_company`
  ADD PRIMARY KEY (`outsourcing_company_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `modified_by` (`modified_by`),
  ADD KEY `pref_code` (`pref_code`);

--
-- Chỉ mục cho bảng `m_prefecture`
--
ALTER TABLE `m_prefecture`
  ADD PRIMARY KEY (`pref_id`);

--
-- Chỉ mục cho bảng `m_role`
--
ALTER TABLE `m_role`
  ADD PRIMARY KEY (`role_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `modified_by` (`modified_by`);

--
-- Chỉ mục cho bảng `m_role_operation`
--
ALTER TABLE `m_role_operation`
  ADD PRIMARY KEY (`role_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `modified_by` (`modified_by`),
  ADD KEY `operation_id` (`operation_id`);

--
-- Chỉ mục cho bảng `m_supplier`
--
ALTER TABLE `m_supplier`
  ADD PRIMARY KEY (`supplier_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `modified_by` (`modified_by`),
  ADD KEY `pref_code` (`pref_code`);

--
-- Chỉ mục cho bảng `t_arrival`
--
ALTER TABLE `t_arrival`
  ADD PRIMARY KEY (`arrival_id`),
  ADD KEY `asset_approve_account_id` (`asset_approve_account_id`),
  ADD KEY `base_id` (`base_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `inspection_account_id` (`inspection_account_id`),
  ADD KEY `item_id` (`item_id`),
  ADD KEY `item_type_id` (`item_type_id`),
  ADD KEY `modified_by` (`modified_by`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `account_id` (`account_id`);

--
-- Chỉ mục cho bảng `t_asset`
--
ALTER TABLE `t_asset`
  ADD PRIMARY KEY (`asset_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `modified_by` (`modified_by`),
  ADD KEY `arrival_id` (`arrival_id`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `kitting_master_id` (`kitting_master_id`);

--
-- Chỉ mục cho bảng `t_asset_depreciation`
--
ALTER TABLE `t_asset_depreciation`
  ADD PRIMARY KEY (`asset_depreciation_id`),
  ADD KEY `asset_id` (`asset_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `depreciation_rule_id` (`depreciation_rule_id`),
  ADD KEY `modified_by` (`modified_by`);

--
-- Chỉ mục cho bảng `t_asset_set`
--
ALTER TABLE `t_asset_set`
  ADD PRIMARY KEY (`asset_id_set`),
  ADD KEY `asset_set_maker_id` (`asset_set_maker_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `modified_by` (`modified_by`);

--
-- Chỉ mục cho bảng `t_asset_set_asset`
--
ALTER TABLE `t_asset_set_asset`
  ADD PRIMARY KEY (`asset_set_asset_id`),
  ADD KEY `asset_id` (`asset_id`),
  ADD KEY `asset_id_set` (`asset_id_set`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `modified_by` (`modified_by`);

--
-- Chỉ mục cho bảng `t_disposal`
--
ALTER TABLE `t_disposal`
  ADD PRIMARY KEY (`disposal_id`),
  ADD KEY `asset_id` (`asset_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `modified_by` (`modified_by`),
  ADD KEY `outsourcing_company_id` (`outsourcing_company_id`);

--
-- Chỉ mục cho bảng `t_kitting`
--
ALTER TABLE `t_kitting`
  ADD PRIMARY KEY (`kitting_id`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `asset_id` (`asset_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `kitting_user_id` (`kitting_user_id`),
  ADD KEY `modified_by` (`modified_by`),
  ADD KEY `software_confirm_account_id` (`software_confirm_account_id`),
  ADD KEY `hardware_confirm_account_id` (`hardware_confirm_account_id`),
  ADD KEY `kitting_confirm_account_id` (`kitting_confirm_account_id`),
  ADD KEY `functional_confirm_account_id` (`functional_confirm_account_id`);

--
-- Chỉ mục cho bảng `t_message`
--
ALTER TABLE `t_message`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `modified_by` (`modified_by`);

--
-- Chỉ mục cho bảng `t_notification`
--
ALTER TABLE `t_notification`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `modified_by` (`modified_by`);

--
-- Chỉ mục cho bảng `t_notification_to`
--
ALTER TABLE `t_notification_to`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `base_id` (`base_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `group_id` (`group_id`),
  ADD KEY `modified_by` (`modified_by`);

--
-- Chỉ mục cho bảng `t_order`
--
ALTER TABLE `t_order`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `item_id` (`item_id`),
  ADD KEY `modified_by` (`modified_by`),
  ADD KEY `procurement_id` (`procurement_id`),
  ADD KEY `supplier_id` (`supplier_id`),
  ADD KEY `item_id_set` (`item_id_set`),
  ADD KEY `kitting_master_id` (`kitting_master_id`),
  ADD KEY `depreciation_rule_id` (`depreciation_rule_id`);

--
-- Chỉ mục cho bảng `t_pick_up`
--
ALTER TABLE `t_pick_up`
  ADD PRIMARY KEY (`pick_up_id`),
  ADD KEY `asset_id` (`asset_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `modified_by` (`modified_by`),
  ADD KEY `outsourcing_company_id` (`outsourcing_company_id`),
  ADD KEY `account_id` (`account_id`);

--
-- Chỉ mục cho bảng `t_procurement`
--
ALTER TABLE `t_procurement`
  ADD PRIMARY KEY (`procurement_id`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `modified_by` (`modified_by`),
  ADD KEY `quotation_account_id` (`quotation_account_id`),
  ADD KEY `quotation_requester` (`quotation_requester`),
  ADD KEY `approval_requester` (`approval_requester`);

--
-- Chỉ mục cho bảng `t_repairing`
--
ALTER TABLE `t_repairing`
  ADD PRIMARY KEY (`repairing_id`),
  ADD KEY `asset_id` (`asset_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `modified_by` (`modified_by`),
  ADD KEY `outsourcing_company_id` (`outsourcing_company_id`),
  ADD KEY `account_id` (`account_id`);

--
-- Chỉ mục cho bảng `t_shipping`
--
ALTER TABLE `t_shipping`
  ADD PRIMARY KEY (`shipping_id`),
  ADD KEY `asset_id` (`asset_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `modified_by` (`modified_by`),
  ADD KEY `outsourcing_company_id` (`outsourcing_company_id`),
  ADD KEY `account_id` (`account_id`);

--
-- Chỉ mục cho bảng `t_support`
--
ALTER TABLE `t_support`
  ADD PRIMARY KEY (`support_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `modified_by` (`modified_by`);

--
-- Chỉ mục cho bảng `t_use`
--
ALTER TABLE `t_use`
  ADD PRIMARY KEY (`use_id`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `asset_id` (`asset_id`),
  ADD KEY `base_id` (`base_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `group_id` (`group_id`),
  ADD KEY `modified_by` (`modified_by`);

--
-- Chỉ mục cho bảng `t_user_request`
--
ALTER TABLE `t_user_request`
  ADD PRIMARY KEY (`request_id`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `asset_id` (`asset_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `deleted_by` (`deleted_by`),
  ADD KEY `group_id` (`group_id`),
  ADD KEY `modified_by` (`modified_by`),
  ADD KEY `request_account_id` (`request_account_id`),
  ADD KEY `request_group_id` (`request_group_id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `m_account`
--
ALTER TABLE `m_account`
  MODIFY `account_id` int NOT NULL AUTO_INCREMENT COMMENT 'アカウントID', AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT cho bảng `m_account_base`
--
ALTER TABLE `m_account_base`
  MODIFY `account_base_id` int NOT NULL AUTO_INCREMENT COMMENT 'アカウントベースID';

--
-- AUTO_INCREMENT cho bảng `m_account_group`
--
ALTER TABLE `m_account_group`
  MODIFY `account_group_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT cho bảng `m_base`
--
ALTER TABLE `m_base`
  MODIFY `base_id` int NOT NULL AUTO_INCREMENT COMMENT '拠点ID', AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT cho bảng `m_depreciation_rule`
--
ALTER TABLE `m_depreciation_rule`
  MODIFY `depreciation_rule_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `m_gen_code`
--
ALTER TABLE `m_gen_code`
  MODIFY `gen_code_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;

--
-- AUTO_INCREMENT cho bảng `m_group`
--
ALTER TABLE `m_group`
  MODIFY `group_id` int NOT NULL AUTO_INCREMENT COMMENT 'グループID:1以上であること', AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT cho bảng `m_item`
--
ALTER TABLE `m_item`
  MODIFY `item_id` int NOT NULL AUTO_INCREMENT COMMENT '品目ID', AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT cho bảng `m_item_set`
--
ALTER TABLE `m_item_set`
  MODIFY `item_id_set` int NOT NULL AUTO_INCREMENT COMMENT 'セット用品目ID:セット用の品目の品目ID', AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `m_item_set_item`
--
ALTER TABLE `m_item_set_item`
  MODIFY `item_set_item_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT cho bảng `m_item_type`
--
ALTER TABLE `m_item_type`
  MODIFY `item_type_id` int NOT NULL AUTO_INCREMENT COMMENT 'タイプID', AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `m_kitting`
--
ALTER TABLE `m_kitting`
  MODIFY `kitting_master_id` int NOT NULL AUTO_INCREMENT COMMENT 'キッティングマスタID', AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT cho bảng `m_maker`
--
ALTER TABLE `m_maker`
  MODIFY `maker_id` int NOT NULL AUTO_INCREMENT COMMENT 'メーカーID', AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT cho bảng `m_operation`
--
ALTER TABLE `m_operation`
  MODIFY `operation_id` int NOT NULL AUTO_INCREMENT COMMENT 'オペレーションID';

--
-- AUTO_INCREMENT cho bảng `m_order`
--
ALTER TABLE `m_order`
  MODIFY `order_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT cho bảng `m_order_detail`
--
ALTER TABLE `m_order_detail`
  MODIFY `order_detail_id` int NOT NULL AUTO_INCREMENT COMMENT 'order_detail_id', AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `m_outsourcing_company`
--
ALTER TABLE `m_outsourcing_company`
  MODIFY `outsourcing_company_id` int NOT NULL AUTO_INCREMENT COMMENT '委託先ID', AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT cho bảng `m_prefecture`
--
ALTER TABLE `m_prefecture`
  MODIFY `pref_id` int NOT NULL AUTO_INCREMENT COMMENT '県ID', AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT cho bảng `m_role`
--
ALTER TABLE `m_role`
  MODIFY `role_id` int NOT NULL AUTO_INCREMENT COMMENT 'ロールID';

--
-- AUTO_INCREMENT cho bảng `m_role_operation`
--
ALTER TABLE `m_role_operation`
  MODIFY `role_id` int NOT NULL AUTO_INCREMENT COMMENT 'ロールID';

--
-- AUTO_INCREMENT cho bảng `m_supplier`
--
ALTER TABLE `m_supplier`
  MODIFY `supplier_id` int NOT NULL AUTO_INCREMENT COMMENT '発注先ID';

--
-- AUTO_INCREMENT cho bảng `t_arrival`
--
ALTER TABLE `t_arrival`
  MODIFY `arrival_id` int NOT NULL AUTO_INCREMENT COMMENT '資産ID:資産登録前だが資産IDとする', AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT cho bảng `t_asset`
--
ALTER TABLE `t_asset`
  MODIFY `asset_id` int NOT NULL AUTO_INCREMENT COMMENT '資産ID', AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT cho bảng `t_asset_depreciation`
--
ALTER TABLE `t_asset_depreciation`
  MODIFY `asset_depreciation_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `t_asset_set`
--
ALTER TABLE `t_asset_set`
  MODIFY `asset_id_set` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `t_asset_set_asset`
--
ALTER TABLE `t_asset_set_asset`
  MODIFY `asset_set_asset_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT cho bảng `t_disposal`
--
ALTER TABLE `t_disposal`
  MODIFY `disposal_id` int NOT NULL AUTO_INCREMENT COMMENT '廃棄ID', AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `t_kitting`
--
ALTER TABLE `t_kitting`
  MODIFY `kitting_id` int NOT NULL AUTO_INCREMENT COMMENT 'キットID', AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `t_message`
--
ALTER TABLE `t_message`
  MODIFY `message_id` int NOT NULL AUTO_INCREMENT COMMENT 'メッセージID';

--
-- AUTO_INCREMENT cho bảng `t_notification`
--
ALTER TABLE `t_notification`
  MODIFY `notification_id` int NOT NULL AUTO_INCREMENT COMMENT '通知ID';

--
-- AUTO_INCREMENT cho bảng `t_notification_to`
--
ALTER TABLE `t_notification_to`
  MODIFY `notification_id` int NOT NULL AUTO_INCREMENT COMMENT '通知先ID:自動採番';

--
-- AUTO_INCREMENT cho bảng `t_order`
--
ALTER TABLE `t_order`
  MODIFY `order_id` int NOT NULL AUTO_INCREMENT COMMENT '発注明細ID:自動採番', AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT cho bảng `t_pick_up`
--
ALTER TABLE `t_pick_up`
  MODIFY `pick_up_id` int NOT NULL AUTO_INCREMENT COMMENT '集荷ID', AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `t_procurement`
--
ALTER TABLE `t_procurement`
  MODIFY `procurement_id` int NOT NULL AUTO_INCREMENT COMMENT '調達ID', AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT cho bảng `t_repairing`
--
ALTER TABLE `t_repairing`
  MODIFY `repairing_id` int NOT NULL AUTO_INCREMENT COMMENT '修理ID', AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `t_shipping`
--
ALTER TABLE `t_shipping`
  MODIFY `shipping_id` int NOT NULL AUTO_INCREMENT COMMENT '出荷ID', AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT cho bảng `t_support`
--
ALTER TABLE `t_support`
  MODIFY `support_id` int NOT NULL AUTO_INCREMENT COMMENT '問合せID';

--
-- AUTO_INCREMENT cho bảng `t_use`
--
ALTER TABLE `t_use`
  MODIFY `use_id` int NOT NULL AUTO_INCREMENT COMMENT '利用ID';

--
-- AUTO_INCREMENT cho bảng `t_user_request`
--
ALTER TABLE `t_user_request`
  MODIFY `request_id` int NOT NULL AUTO_INCREMENT COMMENT '申請ID';

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `m_account_base`
--
ALTER TABLE `m_account_base`
  ADD CONSTRAINT `m_account_base_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_account_base_ibfk_2` FOREIGN KEY (`base_id`) REFERENCES `m_base` (`base_id`),
  ADD CONSTRAINT `m_account_base_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_account_base_ibfk_4` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_account_base_ibfk_5` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `m_account_group`
--
ALTER TABLE `m_account_group`
  ADD CONSTRAINT `m_account_group_ibfk_1` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_account_group_ibfk_2` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_account_group_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_account_group_ibfk_4` FOREIGN KEY (`group_id`) REFERENCES `m_group` (`group_id`),
  ADD CONSTRAINT `m_account_group_ibfk_5` FOREIGN KEY (`account_id`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_account_group_ibfk_6` FOREIGN KEY (`account_id`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_account_group_ibfk_7` FOREIGN KEY (`account_id`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `m_account_role`
--
ALTER TABLE `m_account_role`
  ADD CONSTRAINT `m_account_role_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_account_role_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_account_role_ibfk_3` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_account_role_ibfk_4` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_account_role_ibfk_5` FOREIGN KEY (`role_id`) REFERENCES `m_role` (`role_id`);

--
-- Các ràng buộc cho bảng `m_base`
--
ALTER TABLE `m_base`
  ADD CONSTRAINT `m_base_ibfk_1` FOREIGN KEY (`pref_code`) REFERENCES `m_prefecture` (`pref_id`),
  ADD CONSTRAINT `m_base_ibfk_10` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_base_ibfk_11` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_base_ibfk_12` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_base_ibfk_2` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_base_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_base_ibfk_4` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_base_ibfk_5` FOREIGN KEY (`pref_code`) REFERENCES `m_prefecture` (`pref_id`),
  ADD CONSTRAINT `m_base_ibfk_6` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_base_ibfk_7` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_base_ibfk_8` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_base_ibfk_9` FOREIGN KEY (`pref_code`) REFERENCES `m_prefecture` (`pref_id`);

--
-- Các ràng buộc cho bảng `m_depreciation_rule`
--
ALTER TABLE `m_depreciation_rule`
  ADD CONSTRAINT `m_depreciation_rule_ibfk_1` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_depreciation_rule_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_depreciation_rule_ibfk_3` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `m_group`
--
ALTER TABLE `m_group`
  ADD CONSTRAINT `m_group_ibfk_1` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_group_ibfk_2` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_group_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `m_item`
--
ALTER TABLE `m_item`
  ADD CONSTRAINT `m_item_ibfk_1` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_item_ibfk_2` FOREIGN KEY (`maker_id`) REFERENCES `m_maker` (`maker_id`),
  ADD CONSTRAINT `m_item_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_item_ibfk_4` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `m_item_set`
--
ALTER TABLE `m_item_set`
  ADD CONSTRAINT `m_item_set_ibfk_1` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_item_set_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_item_set_ibfk_3` FOREIGN KEY (`item_set_maker_id`) REFERENCES `m_maker` (`maker_id`),
  ADD CONSTRAINT `m_item_set_ibfk_4` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `m_item_set_item`
--
ALTER TABLE `m_item_set_item`
  ADD CONSTRAINT `m_item_set_item_ibfk_1` FOREIGN KEY (`item_id_set`) REFERENCES `m_item_set` (`item_id_set`),
  ADD CONSTRAINT `m_item_set_item_ibfk_2` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_item_set_item_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_item_set_item_ibfk_4` FOREIGN KEY (`item_id`) REFERENCES `m_item` (`item_id`),
  ADD CONSTRAINT `m_item_set_item_ibfk_5` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `m_item_type`
--
ALTER TABLE `m_item_type`
  ADD CONSTRAINT `m_item_type_ibfk_1` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_item_type_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_item_type_ibfk_3` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `m_kitting`
--
ALTER TABLE `m_kitting`
  ADD CONSTRAINT `m_kitting_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_kitting_ibfk_2` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_kitting_ibfk_3` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `m_maker`
--
ALTER TABLE `m_maker`
  ADD CONSTRAINT `m_maker_ibfk_1` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_maker_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_maker_ibfk_3` FOREIGN KEY (`pref_code`) REFERENCES `m_prefecture` (`pref_id`),
  ADD CONSTRAINT `m_maker_ibfk_4` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `m_operation`
--
ALTER TABLE `m_operation`
  ADD CONSTRAINT `m_operation_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_operation_ibfk_2` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_operation_ibfk_3` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `m_order`
--
ALTER TABLE `m_order`
  ADD CONSTRAINT `m_order_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_order_ibfk_2` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_order_ibfk_3` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `m_order_detail`
--
ALTER TABLE `m_order_detail`
  ADD CONSTRAINT `m_order_detail_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_order_detail_ibfk_2` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_order_detail_ibfk_3` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_order_detail_ibfk_4` FOREIGN KEY (`order_id`) REFERENCES `m_order` (`order_id`);

--
-- Các ràng buộc cho bảng `m_outsourcing_company`
--
ALTER TABLE `m_outsourcing_company`
  ADD CONSTRAINT `m_outsourcing_company_ibfk_1` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_outsourcing_company_ibfk_2` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_outsourcing_company_ibfk_3` FOREIGN KEY (`pref_code`) REFERENCES `m_prefecture` (`pref_id`),
  ADD CONSTRAINT `m_outsourcing_company_ibfk_4` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `m_role`
--
ALTER TABLE `m_role`
  ADD CONSTRAINT `m_role_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_role_ibfk_2` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_role_ibfk_3` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `m_role_operation`
--
ALTER TABLE `m_role_operation`
  ADD CONSTRAINT `m_role_operation_ibfk_1` FOREIGN KEY (`operation_id`) REFERENCES `m_operation` (`operation_id`),
  ADD CONSTRAINT `m_role_operation_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_role_operation_ibfk_3` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_role_operation_ibfk_4` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `m_supplier`
--
ALTER TABLE `m_supplier`
  ADD CONSTRAINT `m_supplier_ibfk_1` FOREIGN KEY (`pref_code`) REFERENCES `m_prefecture` (`pref_id`),
  ADD CONSTRAINT `m_supplier_ibfk_2` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_supplier_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `m_supplier_ibfk_4` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `t_arrival`
--
ALTER TABLE `t_arrival`
  ADD CONSTRAINT `t_arrival_ibfk_1` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_arrival_ibfk_10` FOREIGN KEY (`base_id`) REFERENCES `m_base` (`base_id`),
  ADD CONSTRAINT `t_arrival_ibfk_11` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_arrival_ibfk_12` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_arrival_ibfk_13` FOREIGN KEY (`account_id`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_arrival_ibfk_14` FOREIGN KEY (`inspection_account_id`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_arrival_ibfk_15` FOREIGN KEY (`item_id`) REFERENCES `m_item` (`item_id`),
  ADD CONSTRAINT `t_arrival_ibfk_16` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_arrival_ibfk_17` FOREIGN KEY (`asset_approve_account_id`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_arrival_ibfk_18` FOREIGN KEY (`item_type_id`) REFERENCES `m_item_type` (`item_type_id`),
  ADD CONSTRAINT `t_arrival_ibfk_19` FOREIGN KEY (`order_id`) REFERENCES `t_order` (`order_id`),
  ADD CONSTRAINT `t_arrival_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_arrival_ibfk_20` FOREIGN KEY (`base_id`) REFERENCES `m_base` (`base_id`),
  ADD CONSTRAINT `t_arrival_ibfk_3` FOREIGN KEY (`account_id`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_arrival_ibfk_4` FOREIGN KEY (`inspection_account_id`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_arrival_ibfk_5` FOREIGN KEY (`item_id`) REFERENCES `m_item` (`item_id`),
  ADD CONSTRAINT `t_arrival_ibfk_6` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_arrival_ibfk_7` FOREIGN KEY (`asset_approve_account_id`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_arrival_ibfk_8` FOREIGN KEY (`item_type_id`) REFERENCES `m_item_type` (`item_type_id`),
  ADD CONSTRAINT `t_arrival_ibfk_9` FOREIGN KEY (`order_id`) REFERENCES `t_order` (`order_id`);

--
-- Các ràng buộc cho bảng `t_asset`
--
ALTER TABLE `t_asset`
  ADD CONSTRAINT `t_asset_ibfk_1` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_asset_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_asset_ibfk_3` FOREIGN KEY (`kitting_master_id`) REFERENCES `m_kitting` (`kitting_master_id`),
  ADD CONSTRAINT `t_asset_ibfk_4` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_asset_ibfk_5` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_asset_ibfk_6` FOREIGN KEY (`kitting_master_id`) REFERENCES `m_kitting` (`kitting_master_id`),
  ADD CONSTRAINT `t_asset_ibfk_7` FOREIGN KEY (`arrival_id`) REFERENCES `t_arrival` (`arrival_id`),
  ADD CONSTRAINT `t_asset_ibfk_8` FOREIGN KEY (`account_id`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_asset_ibfk_9` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `t_asset_depreciation`
--
ALTER TABLE `t_asset_depreciation`
  ADD CONSTRAINT `t_asset_depreciation_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_asset_depreciation_ibfk_2` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_asset_depreciation_ibfk_3` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_asset_depreciation_ibfk_4` FOREIGN KEY (`depreciation_rule_id`) REFERENCES `m_depreciation_rule` (`depreciation_rule_id`),
  ADD CONSTRAINT `t_asset_depreciation_ibfk_5` FOREIGN KEY (`asset_id`) REFERENCES `t_asset` (`asset_id`);

--
-- Các ràng buộc cho bảng `t_asset_set`
--
ALTER TABLE `t_asset_set`
  ADD CONSTRAINT `t_asset_set_ibfk_1` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_asset_set_ibfk_2` FOREIGN KEY (`asset_set_maker_id`) REFERENCES `m_maker` (`maker_id`),
  ADD CONSTRAINT `t_asset_set_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_asset_set_ibfk_4` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `t_asset_set_asset`
--
ALTER TABLE `t_asset_set_asset`
  ADD CONSTRAINT `t_asset_set_asset_ibfk_1` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_asset_set_asset_ibfk_2` FOREIGN KEY (`asset_id_set`) REFERENCES `t_asset_set` (`asset_id_set`),
  ADD CONSTRAINT `t_asset_set_asset_ibfk_3` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_asset_set_asset_ibfk_4` FOREIGN KEY (`asset_id`) REFERENCES `t_asset` (`asset_id`),
  ADD CONSTRAINT `t_asset_set_asset_ibfk_5` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `t_disposal`
--
ALTER TABLE `t_disposal`
  ADD CONSTRAINT `t_disposal_ibfk_1` FOREIGN KEY (`outsourcing_company_id`) REFERENCES `m_outsourcing_company` (`outsourcing_company_id`),
  ADD CONSTRAINT `t_disposal_ibfk_2` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_disposal_ibfk_3` FOREIGN KEY (`asset_id`) REFERENCES `t_asset` (`asset_id`),
  ADD CONSTRAINT `t_disposal_ibfk_4` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_disposal_ibfk_5` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `t_kitting`
--
ALTER TABLE `t_kitting`
  ADD CONSTRAINT `t_kitting_ibfk_1` FOREIGN KEY (`kitting_confirm_account_id`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_kitting_ibfk_10` FOREIGN KEY (`asset_id`) REFERENCES `t_asset` (`asset_id`),
  ADD CONSTRAINT `t_kitting_ibfk_2` FOREIGN KEY (`account_id`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_kitting_ibfk_3` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_kitting_ibfk_4` FOREIGN KEY (`kitting_user_id`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_kitting_ibfk_5` FOREIGN KEY (`software_confirm_account_id`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_kitting_ibfk_6` FOREIGN KEY (`hardware_confirm_account_id`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_kitting_ibfk_7` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_kitting_ibfk_8` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_kitting_ibfk_9` FOREIGN KEY (`functional_confirm_account_id`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `t_message`
--
ALTER TABLE `t_message`
  ADD CONSTRAINT `t_message_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_message_ibfk_2` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_message_ibfk_3` FOREIGN KEY (`account_id`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_message_ibfk_4` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `t_notification`
--
ALTER TABLE `t_notification`
  ADD CONSTRAINT `t_notification_ibfk_1` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_notification_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_notification_ibfk_3` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `t_notification_to`
--
ALTER TABLE `t_notification_to`
  ADD CONSTRAINT `t_notification_to_ibfk_1` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_notification_to_ibfk_2` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_notification_to_ibfk_3` FOREIGN KEY (`base_id`) REFERENCES `m_base` (`base_id`),
  ADD CONSTRAINT `t_notification_to_ibfk_4` FOREIGN KEY (`account_id`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_notification_to_ibfk_5` FOREIGN KEY (`group_id`) REFERENCES `m_group` (`group_id`),
  ADD CONSTRAINT `t_notification_to_ibfk_6` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `t_order`
--
ALTER TABLE `t_order`
  ADD CONSTRAINT `t_order_ibfk_1` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_order_ibfk_2` FOREIGN KEY (`item_id_set`) REFERENCES `m_item_set` (`item_id_set`),
  ADD CONSTRAINT `t_order_ibfk_3` FOREIGN KEY (`kitting_master_id`) REFERENCES `m_kitting` (`kitting_master_id`),
  ADD CONSTRAINT `t_order_ibfk_4` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_order_ibfk_5` FOREIGN KEY (`item_id`) REFERENCES `m_item` (`item_id`),
  ADD CONSTRAINT `t_order_ibfk_6` FOREIGN KEY (`supplier_id`) REFERENCES `m_supplier` (`supplier_id`),
  ADD CONSTRAINT `t_order_ibfk_7` FOREIGN KEY (`procurement_id`) REFERENCES `t_procurement` (`procurement_id`),
  ADD CONSTRAINT `t_order_ibfk_8` FOREIGN KEY (`depreciation_rule_id`) REFERENCES `m_depreciation_rule` (`depreciation_rule_id`),
  ADD CONSTRAINT `t_order_ibfk_9` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `t_pick_up`
--
ALTER TABLE `t_pick_up`
  ADD CONSTRAINT `t_pick_up_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_pick_up_ibfk_2` FOREIGN KEY (`account_id`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_pick_up_ibfk_3` FOREIGN KEY (`outsourcing_company_id`) REFERENCES `m_outsourcing_company` (`outsourcing_company_id`),
  ADD CONSTRAINT `t_pick_up_ibfk_4` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_pick_up_ibfk_5` FOREIGN KEY (`asset_id`) REFERENCES `t_asset` (`asset_id`),
  ADD CONSTRAINT `t_pick_up_ibfk_6` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `t_procurement`
--
ALTER TABLE `t_procurement`
  ADD CONSTRAINT `t_procurement_ibfk_1` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_procurement_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_procurement_ibfk_3` FOREIGN KEY (`quotation_account_id`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_procurement_ibfk_4` FOREIGN KEY (`account_id`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_procurement_ibfk_5` FOREIGN KEY (`quotation_requester`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_procurement_ibfk_6` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_procurement_ibfk_7` FOREIGN KEY (`approval_requester`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `t_repairing`
--
ALTER TABLE `t_repairing`
  ADD CONSTRAINT `t_repairing_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_repairing_ibfk_2` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_repairing_ibfk_3` FOREIGN KEY (`asset_id`) REFERENCES `t_asset` (`asset_id`),
  ADD CONSTRAINT `t_repairing_ibfk_4` FOREIGN KEY (`account_id`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_repairing_ibfk_5` FOREIGN KEY (`outsourcing_company_id`) REFERENCES `m_outsourcing_company` (`outsourcing_company_id`),
  ADD CONSTRAINT `t_repairing_ibfk_6` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `t_shipping`
--
ALTER TABLE `t_shipping`
  ADD CONSTRAINT `t_shipping_ibfk_1` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_shipping_ibfk_2` FOREIGN KEY (`asset_id`) REFERENCES `t_asset` (`asset_id`),
  ADD CONSTRAINT `t_shipping_ibfk_3` FOREIGN KEY (`account_id`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_shipping_ibfk_4` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_shipping_ibfk_5` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_shipping_ibfk_6` FOREIGN KEY (`outsourcing_company_id`) REFERENCES `m_outsourcing_company` (`outsourcing_company_id`);

--
-- Các ràng buộc cho bảng `t_support`
--
ALTER TABLE `t_support`
  ADD CONSTRAINT `t_support_ibfk_1` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_support_ibfk_2` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_support_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `t_use`
--
ALTER TABLE `t_use`
  ADD CONSTRAINT `t_use_ibfk_1` FOREIGN KEY (`base_id`) REFERENCES `m_base` (`base_id`),
  ADD CONSTRAINT `t_use_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_use_ibfk_3` FOREIGN KEY (`group_id`) REFERENCES `m_group` (`group_id`),
  ADD CONSTRAINT `t_use_ibfk_4` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_use_ibfk_5` FOREIGN KEY (`asset_id`) REFERENCES `t_asset` (`asset_id`),
  ADD CONSTRAINT `t_use_ibfk_6` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_use_ibfk_7` FOREIGN KEY (`account_id`) REFERENCES `m_account` (`account_id`);

--
-- Các ràng buộc cho bảng `t_user_request`
--
ALTER TABLE `t_user_request`
  ADD CONSTRAINT `t_user_request_ibfk_1` FOREIGN KEY (`deleted_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_user_request_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_user_request_ibfk_3` FOREIGN KEY (`group_id`) REFERENCES `m_group` (`group_id`),
  ADD CONSTRAINT `t_user_request_ibfk_4` FOREIGN KEY (`modified_by`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_user_request_ibfk_5` FOREIGN KEY (`request_group_id`) REFERENCES `m_group` (`group_id`),
  ADD CONSTRAINT `t_user_request_ibfk_6` FOREIGN KEY (`request_account_id`) REFERENCES `m_account` (`account_id`),
  ADD CONSTRAINT `t_user_request_ibfk_7` FOREIGN KEY (`asset_id`) REFERENCES `t_asset` (`asset_id`),
  ADD CONSTRAINT `t_user_request_ibfk_8` FOREIGN KEY (`account_id`) REFERENCES `m_account` (`account_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
