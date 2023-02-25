# Onboarding new election type

Instead of using active record base inheritance with a single unified table,
each election type is backed by a new table.
Thus migrations that affect Election need to
be persisted to every subclass in this directory.
There also needs to be an additional foriegn key added to the votes table.
