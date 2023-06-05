from chalicelib.controllers.kitting_controller import kitting_bp
from chalicelib.controllers.item_master_controller import item_info_bp
from chalicelib.controllers.maker_controller import maker_bp
from chalicelib.controllers.outsourcing_company_controller import outsourcing_company_bp
from chalicelib.controllers.prefecture_controller import prefecture_bp
from chalicelib.controllers.item_set_controller import item_set_bp
from chalicelib.controllers.procurement_controller import procurement_bp
from chalicelib.controllers.arrival_controller import arrival_bp
from chalicelib.controllers.base_controller import base_bp
from chalicelib.controllers.gen_code_controller import gen_code_bp
from chalicelib.controllers.t_kitting_controller import t_kitting_bp
from chalicelib.controllers.asset_controller import asset_bp
from chalicelib.controllers.shipping_controller import shipping_bp
from chalicelib.controllers.pickup_controller import pickup_bp
from chalicelib.controllers.repairing_controller import repairing_bp
from chalicelib.controllers.disposal_controller import disposal_bp
from chalicelib.controllers.using_controller import using_bp
from chalicelib.controllers.user_support_controller import support_bp
from chalicelib.controllers.account_controller import account_bp
from chalicelib.controllers.depreciation_rule_controller import depreciation_rule_bp
from chalicelib.controllers.asset_depre_controller import asset_depre_bp
from chalicelib.controllers.asset_set_asset_controller import asset_set_asset_bp
from chalicelib.controllers.lcm_controller import lcm_bp


def init_app(app):
    base_url = '/'
    app.register_blueprint(kitting_bp, url_prefix=base_url)
    app.register_blueprint(item_set_bp, url_prefix=base_url)
    app.register_blueprint(item_info_bp, url_prefix=base_url)
    app.register_blueprint(maker_bp, url_prefix=base_url)
    app.register_blueprint(outsourcing_company_bp, url_prefix=base_url)
    app.register_blueprint(prefecture_bp, url_prefix=base_url)
    app.register_blueprint(procurement_bp, url_prefix=base_url)
    app.register_blueprint(arrival_bp, url_prefix=base_url)
    app.register_blueprint(base_bp, url_prefix=base_url)
    app.register_blueprint(gen_code_bp, url_prefix=base_url)
    app.register_blueprint(t_kitting_bp, url_prefix=base_url)
    app.register_blueprint(asset_bp, url_prefix=base_url)
    app.register_blueprint(shipping_bp, url_prefix=base_url)
    app.register_blueprint(pickup_bp, url_prefix=base_url)
    app.register_blueprint(repairing_bp, url_prefix=base_url)
    app.register_blueprint(disposal_bp, url_prefix=base_url)
    app.register_blueprint(using_bp, url_prefix=base_url)
    app.register_blueprint(support_bp, url_prefix=base_url)
    app.register_blueprint(account_bp, url_prefix=base_url)
    app.register_blueprint(depreciation_rule_bp, url_prefix=base_url)
    app.register_blueprint(asset_depre_bp, url_prefix=base_url)
    app.register_blueprint(asset_set_asset_bp, url_prefix=base_url)
    app.register_blueprint(lcm_bp, url_prefix=base_url)
