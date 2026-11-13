create table buildings (
  id bigint generated always as identity primary key,
  source_id bigint unique check (source_id > 0),
  name text not null unique,
  latitude numeric(11, 8),
  longitude numeric(11, 8),
  is_public boolean,
  description text,
  address text,
  created_at timestamptz not null default now(),
  check ((latitude is null) = (longitude is null)),
  check (latitude between -90 and 90),
  check (longitude between -180 and 180)
);

create table floors (
  id bigint generated always as identity primary key,
  building_id bigint not null references buildings (id) on delete cascade,
  floor_number integer,
  floor_label text not null,
  created_at timestamptz not null default now(),
  unique (building_id, floor_label),
  unique (id, building_id)
);

create table parking_lots (
  id bigint generated always as identity primary key,
  source_id bigint unique check (source_id > 0),
  name text not null,
  latitude numeric(11, 8),
  longitude numeric(11, 8),
  total_ada_spaces integer check (total_ada_spaces >= 0),
  total_van_accessible_spaces integer check (total_van_accessible_spaces >= 0),
  notes text,
  created_at timestamptz not null default now(),
  check ((latitude is null) = (longitude is null)),
  check (latitude between -90 and 90),
  check (longitude between -180 and 180)
);

create table parking_lot_permit_types (
  parking_lot_id bigint not null references parking_lots (id) on delete cascade,
  permit_type text not null,
  primary key (parking_lot_id, permit_type)
);

create table building_parking_lots (
  building_id bigint not null references buildings (id) on delete cascade,
  parking_lot_id bigint not null references parking_lots (id) on delete cascade,
  primary key (building_id, parking_lot_id)
);

create table entrances (
  id bigint generated always as identity primary key,
  source_id bigint unique check (source_id > 0),
  building_id bigint not null references buildings (id) on delete cascade,
  floor_id bigint,
  name text not null,
  door_width_inches numeric(5, 2) check (door_width_inches > 0),
  entrance_system text,
  has_ramp boolean,
  ramp_slope numeric(7, 4) check (ramp_slope > 0),
  step_count integer check (step_count >= 0),
  notes text,
  created_at timestamptz not null default now(),
  foreign key (floor_id, building_id) references floors (id, building_id)
);

create table restrooms (
  id bigint generated always as identity primary key,
  source_id bigint unique check (source_id > 0),
  building_id bigint not null references buildings (id) on delete cascade,
  floor_id bigint,
  room_number text,
  door_width_inches numeric(5, 2) check (door_width_inches > 0),
  designated_gender text,
  is_single_occupancy boolean,
  is_ada_compliant boolean,
  transfer_side text check (transfer_side in ('left', 'right', 'none')),
  has_grab_bars boolean,
  location_notes text,
  created_at timestamptz not null default now(),
  foreign key (floor_id, building_id) references floors (id, building_id)
);

create table amenities (
  id bigint generated always as identity primary key,
  source_id bigint unique check (source_id > 0),
  building_id bigint not null references buildings (id) on delete cascade,
  floor_id bigint,
  amenity_type text not null,
  description text,
  is_accessible boolean,
  notes text,
  created_at timestamptz not null default now(),
  foreign key (floor_id, building_id) references floors (id, building_id)
);

create table elevators (
  id bigint generated always as identity primary key,
  source_id bigint unique check (source_id > 0),
  building_id bigint not null references buildings (id) on delete cascade,
  location_description text not null,
  door_width_inches numeric(5, 2) check (door_width_inches > 0),
  has_braille boolean,
  has_audio_signals boolean,
  keycard_required boolean,
  notes text,
  created_at timestamptz not null default now(),
  unique (id, building_id)
);

create table elevator_stops (
  elevator_id bigint not null,
  floor_id bigint not null,
  building_id bigint not null,
  primary key (elevator_id, floor_id),
  foreign key (elevator_id, building_id) references elevators (id, building_id) on delete cascade,
  foreign key (floor_id, building_id) references floors (id, building_id) on delete cascade
);

create table media_assets (
  id bigint generated always as identity primary key,
  source_id bigint unique check (source_id > 0),
  building_id bigint not null references buildings (id) on delete cascade,
  image_url text not null,
  alt_text text not null,
  caption text,
  created_at timestamptz not null default now()
);
