"""Delete column asset_name and add new column arrival_id into table t_asset

Revision ID: a7411e8c1b00
Revises: e2e73b49d50f
Create Date: 2023-01-12 14:53:49.022694

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import mysql

# revision identifiers, used by Alembic.
revision = 'a7411e8c1b00'
down_revision = 'e2e73b49d50f'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('t_asset', sa.Column(
        'arrival_id', sa.Integer(), nullable=False, comment='資産ID'))
    op.create_foreign_key(None, 't_asset', 't_arrival', [
                          'arrival_id'], ['arrival_id'])
    # ### end Alembic commands ###


def downgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('t_asset', sa.Column('asset_name', mysql.VARCHAR(
        charset='utf8mb4', collation='utf8mb4_unicode_ci', length=200), nullable=True, comment='資産名称'))
    op.drop_constraint(None, 't_asset', type_='foreignkey')
    op.drop_column('t_asset', 'arrival_id')
    # ### end Alembic commands ###