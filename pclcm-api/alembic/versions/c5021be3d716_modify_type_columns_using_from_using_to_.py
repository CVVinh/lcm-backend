"""Modify type columns using_from, using_to in table t_asset

Revision ID: c5021be3d716
Revises: 54794a77e31e
Create Date: 2023-02-22 09:56:19.348735

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import mysql

# revision identifiers, used by Alembic.
revision = 'c5021be3d716'
down_revision = '54794a77e31e'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column("t_asset", "using_from")
    op.drop_column("t_asset", "using_to")
    op.drop_column("t_arrival", "using_from")
    op.drop_column("t_arrival", "using_to")
    op.add_column('t_asset', sa.Column('using_from', sa.Date(), nullable=True))
    op.add_column('t_asset', sa.Column('using_to', sa.Date(), nullable=True))
    op.add_column('t_arrival', sa.Column(
        'using_from', sa.Date(), nullable=True))
    op.add_column('t_arrival', sa.Column('using_to', sa.Date(), nullable=True))
    # ### end Alembic commands ###


def downgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    pass
    # ### end Alembic commands ###
