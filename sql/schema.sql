-- =========================================================================
-- schema.sql - the tables your database is made of
--
-- Project 1 | SQL: From Data to Insight
-- Team:
-- Dataset:
--
-- This is a DELIVERABLE: it is how someone rebuilds your database from
-- nothing, and the tables here must match the ERD you drew.
--
-- Written for SQLite. On MySQL, add a CREATE DATABASE / USE at the top and
-- swap the types (TEXT -> VARCHAR(n), REAL -> DECIMAL, INTEGER PRIMARY KEY
-- -> INT PRIMARY KEY AUTO_INCREMENT).
-- =========================================================================

-- SQLite does not enforce foreign keys unless you ask it to, once per
-- connection. Without this line a broken key is accepted in silence.
PRAGMA foreign_keys = ON;


-- --- Lookup tables -------------------------------------------------------
-- The categorical columns you pulled out: an id and the value it stands for.
-- These have no foreign keys of their own, so they are created and loaded
-- FIRST.
/*
lookup_tbls = {
    'age_groups':        ('Age_Group', 'age_group_id'),
    'genders':            ('Gender', 'gender_id'),
    'membership_levels':  ('Membership_Level', 'membership_id'),
    'location_zones':     ('Location_Zone', 'location_id'),
    'item_categories':    ('Item_Category', 'category_id'),
    'brand_tiers':        ('Brand_Tier', 'brand_tier_id'),
    'device_types':       ('Device_Type', 'device_id'),
    'traffic_sources':    ('Traffic_Source', 'traffic_id'),
}

*/

CREATE TABLE IF NOT EXISTS age_groups(
    age_group_id INTEGER PRIMARY KEY,
    age_group TEXT NOT NULL
);
 
CREATE TABLE IF NOT EXISTS genders(
    gender_id INTEGER PRIMARY KEY,
    gender TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS membership_levels(
    membership_id INTEGER PRIMARY KEY,
    membership_level TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS location_zones(
    location_id INTEGER PRIMARY KEY,
    location_zone TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS item_categories(
    category_id INTEGER PRIMARY KEY,
    item_category TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS brand_tiers(
    brand_tier_id INTEGER PRIMARY KEY,
    brand_tier TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS device_types(
    device_id INTEGER PRIMARY KEY,
    device_type TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS traffic_sources(
    traffic_id INTEGER PRIMARY KEY,
    traffic_source TEXT NOT NULL
);

-- --- Your main table -----------------------------------------------------
-- The rows you are actually analysing: the numbers you care about, plus one
-- foreign key pointing at each lookup table above. Created and loaded LAST,
-- because every key it carries has to already exist somewhere else.

CREATE TABLE IF NOT EXISTS interactions(
    interaction_id INTEGER PRIMARY KEY,
    user_id TEXT NOT NULL,
    item_id TEXT NOT NULL,
    session_id TEXT NOT NULL,

    age_group_id INTEGER,
    gender_id INTEGER,
    membership_id INTEGER,
    location_id INTEGER,
    user_activity_score REAL,
    user_loyalty_score REAL,
    average_order_value REAL,
    past_purchase_count INTEGER,

    category_id INTEGER,
    brand_tier_id INTEGER,
    item_price REAL,
    discount_percentage REAL,
    item_popularity_score REAL,
    item_quality_score REAL,
    stock_availability_score REAL,

    device_id INTEGER,
    traffic_id INTEGER,
    time_of_day TEXT,
    day_type TEXT,
 
    click_count INTEGER,
    view_duration_sec REAL,
    cart_add_count INTEGER,
    wishlist_flag INTEGER,
    purchase_flag INTEGER,
    rating REAL,
    return_flag INTEGER,
    engagement_score REAL,

    FOREIGN KEY (age_group_id)       REFERENCES age_groups(age_group_id),
    FOREIGN KEY (gender_id)          REFERENCES genders(gender_id),
    FOREIGN KEY (membership_id)      REFERENCES membership_levels(membership_id),
    FOREIGN KEY (location_id)        REFERENCES location_zones(location_id),
    FOREIGN KEY (category_id)        REFERENCES item_categories(category_id),
    FOREIGN KEY (brand_tier_id)      REFERENCES brand_tiers(brand_tier_id),
    FOREIGN KEY (device_id)          REFERENCES device_types(device_id),
    FOREIGN KEY (traffic_id)         REFERENCES traffic_sources(traffic_id)
);



-- --- Indexes (optional) --------------------------------------------------
-- Worth adding on your foreign keys if a query starts to feel slow.
