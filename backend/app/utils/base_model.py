"""
Some wrappers on databse objects to simplify the process such as auto adding created at, updated at and id.
This might add to much bloat and have to be removed in the future.
"""
import inspect

from flask_sqlalchemy.model import camel_to_snake_case
from sqlalchemy.ext.declarative import declarative_base

from app import db
from app.utils import pluralize, title_case
from app.utils.date import utcnow
from app.utils.types import BigInteger, DateTime

Base = declarative_base()


class BaseModel(db.Model, Base):
    """Base table class. It includes convenience methods for creating,
    querying, saving, updating and deleting models.
    """

    __abstract__ = True
    __table_args__ = {"extend_existing": True}

    __repr_props__ = ()
    """Set to customize automatic string representation.

    For example::

        class User(database.Model):
            __repr_props__ = ('id', 'email')

            email = Column(String)

        user = User(id=1, email='foo@bar.com')
        print(user)  # prints <User id=1 email="foo@bar.com">
    """

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    def __plural__(self):
        return pluralize(self.__name__)

    def __label__(self):
        return title_case(self.__name__)

    def __plural_label__(self):
        return pluralize(self.__label__)

    @classmethod
    def first(cls):
        """Get all models."""
        return cls.query.first()

    @classmethod
    def all(cls):
        """Get all models."""
        return cls.query.all()

    @classmethod
    def get(cls, id):
        """Get one model by ID.

        :param id: The model ID to get.
        """
        return cls.query.get(int(id))

    @classmethod
    def get_by(cls, **kwargs):
        """Get one model by keyword arguments.

        :param kwargs: The model attribute values to filter by.
        """
        return cls.query.filter_by(**kwargs).first()

    @classmethod
    def get_or_create(cls, commit=False, **kwargs):
        """Get or create model by keyword arguments.

        :param bool commit: Whether or not to immediately commit the DB session (if create).
        :param kwargs: The model attributes to get or create by.
        """
        instance = cls.get_by(**kwargs)
        if not instance:
            instance = cls.create(**kwargs, commit=commit)
        return instance

    @classmethod
    def join(cls, *props, **kwargs):
        return cls.query.join(*props, **kwargs)

    @classmethod
    def filter(cls, *args, **kwargs):
        return cls.query.filter(*args, **kwargs)

    @classmethod
    def filter_by(cls, **kwargs):
        """Find models by keyword arguments.

        :param kwargs: The model attribute values to filter by.
        """
        return cls.query.filter_by(**kwargs)

    @classmethod
    def create(cls, commit=False, **kwargs):
        """Create a new model and add it to the database session.

        :param bool commit: Whether or not to immediately commit the DB session.
        :param kwargs: The model attribute values to create the model with.
        """
        instance = cls(**kwargs)
        return instance.save(commit)

    def update(self, commit=False, **kwargs):
        """Update fields on the model.

        :param bool commit: Whether or not to immediately commit the DB session.
        :param kwargs: The model attribute values to update the model with.
        """
        for attr, value in kwargs.items():
            setattr(self, attr, value)
        return self.save(commit)

    def save(self, commit=False):
        """Save the model.

        :param bool commit: Whether or not to immediately commit the DB session.
        """
        db.session.add(self)
        if commit:
            db.session.commit()
        return self

    def delete(self, commit=False):
        """Delete the model.

        :param bool commit: Whether or not to immediately commit the DB session.
        """
        db.session.delete(self)
        return commit and db.session.commit()

    def __repr__(self):
        properties = [
            f"{prop}={getattr(self, prop)!r}"
            for prop in self.__repr_props__
            if hasattr(self, prop)
        ]
        return f"<{self.__class__.__name__} {' '.join(properties)}>"

    def save_fixture(self):
        from sqlalchemy import inspect

        def get_row_dic(row):
            return {
                c.key: getattr(row, c.key) for c in inspect(row).mapper.column_attrs
            }

        return {
            "table": camel_to_snake_case(self.__class__.__name__),
            "records": [get_row_dic(row) for row in self.all()],
        }


class Column(db.Column):
    """
    Overridden to make nullable False by default
    """

    def __init__(self, *args, nullable=True, **kwargs):
        super().__init__(*args, nullable=nullable, **kwargs)


class PrimaryKeyMixin(object):
    """
    Adds an :attr:`id` primary key column to a Model
    """

    id = Column(BigInteger, primary_key=True)


class TimestampMixin(object):
    """
    Adds automatically timestamped :attr:`created_at` and :attr:`updated_at`
    columns to a Model
    """

    created_at = Column(DateTime, default=utcnow())
    updated_at = Column(DateTime, default=utcnow(), onupdate=utcnow())


class Model(PrimaryKeyMixin, TimestampMixin, BaseModel):
    """Base table class that extends :class:`backend.database.BaseModel` and
    includes a primary key :attr:`id` field along with automatically
    date-stamped :attr:`created_at` and :attr:`updated_at` fields.
    """

    __abstract__ = True
    __table_args__ = {"extend_existing": True}

    __repr_props__ = ("id", "created_at", "updated_at")

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        super().__init__()


from sqlalchemy.orm.relationships import RelationshipProperty


class __relationship_type_hinter__(RelationshipProperty):
    # implement __call__ to silence the silly "not callable" warning
    def __call__(self, *args, **kwargs):
        pass


# alias common names
backref = db.backref  # type: __relationship_type_hinter__
relationship = db.relationship  # type: __relationship_type_hinter__


def foreign_key(
    model_or_table_name,
    fk_col=None,
    primary_key=False,
    nullable=True,
    deferrable=True,
    foreign_key_args=None,
    **kwargs,
):
    """Helper method to add a foreign key Column to a model.

    For example::

        class Post(Model):
            category_id = foreign_key('Category')
            category = relationship('Category', back_populates='posts')

    Is equivalent to::

        class Post(Model):
            category_id = Column(BigInteger, ForeignKey('category.id'), nullable=False)
            category = relationship('Category', back_populates='posts')

    :param deferrable:
    :param nullable:
    :param model_or_table_name: the model or table name to link to

        If given a lowercase string, it's treated as an explicit table name.

        If there are any uppercase characters, it's assumed to be a model name,
        and will be converted to snake case using the same automatic conversion
        as Flask-SQLAlchemy does itself.

        If given an instance of :class:`flask_sqlalchemy.Model`, use its
        :attr:`__tablename__` attribute.

    :param str fk_col: column name of the primary key (defaults to "id")
    :param bool primary_key: Whether or not this Column is a primary key
    :param dict kwargs: any other kwargs to pass the Column constructor
    """
    if foreign_key_args is None:
        foreign_key_args = {}
    model = model_or_table_name
    table_name = model_or_table_name
    fk_col = fk_col or "id"
    if inspect.isclass(model) and issubclass(model, db.Model):
        table_name = model_or_table_name.__tablename__
    elif table_name != table_name.lower():
        table_name = camel_to_snake_case(table_name)
    return Column(
        db.BigInteger,
        db.ForeignKey(
            f"{table_name}.{fk_col}", deferrable=deferrable, **foreign_key_args
        ),
        primary_key=primary_key,
        nullable=nullable,
        **kwargs,
    )
