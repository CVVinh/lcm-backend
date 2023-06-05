"""Modify type column amount in table t_order

Revision ID: 771a17874e70
Revises: f49c7b4ec4ac
Create Date: 2023-02-20 14:10:35.153036

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import mysql


# revision identifiers, used by Alembic.
revision = '771a17874e70'
down_revision = 'f49c7b4ec4ac'
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.alter_column('t_order', 'amount',
                    existing_type=mysql.FLOAT(),
                    nullable=True)


def downgrade() -> None:
    pass
