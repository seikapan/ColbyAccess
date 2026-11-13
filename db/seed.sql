truncate table buildings, parking_lots restart identity cascade;

insert into buildings (source_id, name, latitude, longitude, is_public, description, address)
values
  (1, 'Lorimer Chapel', 44.56249202732245, -69.66344339568975, true, 'Floors 1–3 audited; floor 3 has hillside ground-level accessible entry. Chapel stage on floor 2 is stairs-only; no ramp; four small first-floor restrooms with narrow doors.', '4000 Mayflower Hill Dr, Waterville, ME 04901'),
  (2, 'Colby College Bookstore', 44.56262256595619, -69.66154068610241, true, 'Bookstore reached by elevator to ground floor; adjacent Page Commons, spa and Pew Center entrances audited separately.', '5400 Mayflower Hill Dr, Waterville, ME 04901'),
  (3, 'Colby College Museum of Art', 44.56504, -69.66062, true, null, '5600 Mayflower Hill Dr, Waterville, ME 04901'),
  (null, 'Spa', null, null, null, null, null),
  (null, 'Page Commons', null, null, null, null, null),
  (null, 'Pew Center', null, null, null, null, null);

insert into floors (building_id, floor_number, floor_label)
select buildings.id, source.floor_number, source.floor_label
from (
  values
    (1, 1, '1'),
    (1, 2, '2'),
    (1, 3, '3')
) as source(building_source_id, floor_number, floor_label)
join buildings on buildings.source_id = source.building_source_id;

insert into parking_lots (source_id, name, latitude, longitude, total_ada_spaces, total_van_accessible_spaces, notes)
values
  (1, 'Lorimer Chapel Accessible Parking', 44.562171, -69.662960, 4, 0, null),
  (2, 'Cotter Union Accessible Parking', 44.563111, -69.662320, 2, 0, null),
  (3, 'Roberts Lot Museum Parking', 44.565599, -69.660918, null, null, null);

insert into parking_lot_permit_types (parking_lot_id, permit_type)
select parking_lots.id, source.permit_type
from (
  values
    (1, 'Accessible Parking Placard'),
    (2, 'Accessible Parking Placard'),
    (3, 'Museum Visitor'),
    (3, 'Accessible Parking Placard')
) as source(parking_lot_source_id, permit_type)
join parking_lots on parking_lots.source_id = source.parking_lot_source_id;

insert into building_parking_lots (building_id, parking_lot_id)
select buildings.id, parking_lots.id
from (
  values
    (1, 1),
    (3, 3)
) as source(building_source_id, parking_lot_source_id)
join buildings on buildings.source_id = source.building_source_id
join parking_lots on parking_lots.source_id = source.parking_lot_source_id;

insert into entrances (source_id, building_id, floor_id, name, door_width_inches, entrance_system, has_ramp, ramp_slope, step_count, notes)
select source.source_id, buildings.id, floors.id, source.name, source.door_width_inches, source.entrance_system, source.has_ramp, source.ramp_slope, source.step_count, source.notes
from (
  values
    (1, 'Lorimer Chapel', 1, 'Lorimer Chapel – first-floor side door', 41::numeric, null::text, null::boolean, null::numeric, null::integer, '3 ft 5 in = 41 in; first floor.'),
    (2, 'Lorimer Chapel', 1, 'Lorimer Chapel – first-floor elevator approach', 30::numeric, null::text, null::boolean, null::numeric, null::integer, '2 ft 6 in = 30 in; distinguished from 35 in elevator car door.'),
    (3, 'Lorimer Chapel', 2, 'Lorimer Chapel – second-floor elevator approach', 33::numeric, null::text, null::boolean, null::numeric, null::integer, 'Approx. 33 in opening from elevator into chapel atrium.'),
    (4, 'Lorimer Chapel', 2, 'Lorimer Chapel – main exterior chapel entrance', 55::numeric, null::text, null::boolean, null::numeric, null::integer, '4 ft 7 in = 55 in; slight threshold lip flagged as potential barrier.'),
    (5, 'Lorimer Chapel', 2, 'Lorimer Chapel – inner chapel entrance', 52::numeric, null::text, null::boolean, null::numeric, null::integer, '4 ft 4 in = 52 in; beyond exterior main doors.'),
    (6, 'Lorimer Chapel', 3, 'Lorimer Chapel – dedicated accessible entrance', 34::numeric, null::text, null::boolean, null::numeric, null::integer, 'Floor 3 hillside ground level; identified as most viable wheelchair entry.'),
    (7, 'Lorimer Chapel', 3, 'Lorimer Chapel – interior kitchen entrance', 31::numeric, null::text, null::boolean, null::numeric, null::integer, 'Approx. 31 in door.'),
    (8, 'Lorimer Chapel', 3, 'Lorimer Chapel – exterior kitchen outer door', 37::numeric, null::text, null::boolean, null::numeric, null::integer, 'Third-floor kitchen exterior route has many stairs and is not wheelchair accessible.'),
    (9, 'Lorimer Chapel', 3, 'Lorimer Chapel – exterior kitchen inner door', 33::numeric, null::text, null::boolean, null::numeric, null::integer, 'Approx. 33 in; same exterior kitchen route with many stairs.'),
    (10, 'Spa', null::integer, 'Spa – main entrance', 32::numeric, null::text, null::boolean, null::numeric, null::integer, 'Approx. 32 in; generous estimate. Building affiliation requires confirmation.'),
    (11, 'Page Commons', null::integer, 'Page Commons – inner doors', 32::numeric, null::text, null::boolean, null::numeric, null::integer, 'Approx. 32 in; multiple interior doors reported; count not specified.'),
    (12, 'Colby College Bookstore', null::integer, 'Colby College Bookstore – entrance', null::numeric, null::text, null::boolean, null::numeric, null::integer, 'Described as wide enough; not measured. Wheelchair access primarily via ground-floor elevator.'),
    (13, 'Pew Center', null::integer, 'Pew Center – entrance doors', 32::numeric, null::text, null::boolean, null::numeric, null::integer, 'Each of two separate doors approx. 32 in; do not add widths. Two-door vestibule with stairs restricts access.'),
    (14, 'Spa', null::integer, 'Spa – back / secondary entrance', 32::numeric, null::text, null::boolean, null::numeric, null::integer, 'Approx. 32 in; double-door vestibule inconvenient. Building affiliation requires confirmation.')
) as source(source_id, building_name, floor_number, name, door_width_inches, entrance_system, has_ramp, ramp_slope, step_count, notes)
join buildings on buildings.name = source.building_name
left join floors on floors.building_id = buildings.id and floors.floor_number = source.floor_number;

insert into restrooms (source_id, building_id, floor_id, room_number, door_width_inches, designated_gender, is_single_occupancy, is_ada_compliant, transfer_side, has_grab_bars, location_notes)
select source.source_id, buildings.id, floors.id, source.room_number, source.door_width_inches, source.designated_gender, source.is_single_occupancy, source.is_ada_compliant, source.transfer_side, source.has_grab_bars, source.location_notes
from (
  values
    (1, 'Lorimer Chapel', 1, null::text, 25::numeric, 'All', true, false, 'none', false, 'Lorimer Chapel floor 1 (sometimes labeled ground): one of four small single-use restrooms; ~25in is a generous estimate; two larger and two smaller bathrooms overall.'),
    (2, 'Lorimer Chapel', 1, null::text, 25::numeric, 'All', true, null::boolean, null::text, null::boolean, 'Lorimer Chapel floor 1 (sometimes labeled ground): one of four small single-use restrooms; ~25in is a generous estimate; two larger and two smaller bathrooms overall.'),
    (3, 'Lorimer Chapel', 1, null::text, 25::numeric, 'All', true, null::boolean, null::text, null::boolean, 'Lorimer Chapel floor 1 (sometimes labeled ground): one of four small single-use restrooms; ~25in is a generous estimate; two larger and two smaller bathrooms overall.'),
    (4, 'Lorimer Chapel', 1, null::text, 25::numeric, 'All', true, null::boolean, null::text, null::boolean, 'Lorimer Chapel floor 1 (sometimes labeled ground): one of four small single-use restrooms; ~25in is a generous estimate; two larger and two smaller bathrooms overall.'),
    (5, 'Lorimer Chapel', 3, null::text, 31::numeric, null::text, null::boolean, null::boolean, null::text, null::boolean, 'Lorimer Chapel floor 3: bathroom described as accessible in audit; 31in entrance; formal compliance unverified.'),
    (6, 'Colby College Bookstore', null::integer, null::text, 32::numeric, null::text, null::boolean, null::boolean, 'right', true, 'Colby bookstore / surrounding building: accessible stall; grab bar on right; 32 in bathroom entrance. Floor level not specified. All accessible stalls observed had right-side bars.')
) as source(source_id, building_name, floor_number, room_number, door_width_inches, designated_gender, is_single_occupancy, is_ada_compliant, transfer_side, has_grab_bars, location_notes)
join buildings on buildings.name = source.building_name
left join floors on floors.building_id = buildings.id and floors.floor_number = source.floor_number;

insert into amenities (source_id, building_id, floor_id, amenity_type, description, is_accessible, notes)
select source.source_id, buildings.id, floors.id, source.amenity_type, source.description, source.is_accessible, source.notes
from (
  values
    (1, 'Lorimer Chapel', 2, 'Stage/podium', 'Lorimer Chapel second-floor stage; stair-only access, no ramp.', false, 'Wheelchair access to stage not possible; major barrier for speakers with disabilities.'),
    (2, 'Lorimer Chapel', 2, 'Upper atrium', 'Lorimer Chapel upper atrium section locked; reservation required (CBB use).', null::boolean, 'Access restrictions observed; physical accessibility not established.')
) as source(source_id, building_name, floor_number, amenity_type, description, is_accessible, notes)
join buildings on buildings.name = source.building_name
join floors on floors.building_id = buildings.id and floors.floor_number = source.floor_number;

insert into elevators (source_id, building_id, location_description, door_width_inches, has_braille, has_audio_signals, keycard_required, notes)
select source.source_id, buildings.id, source.location_description, source.door_width_inches, source.has_braille, source.has_audio_signals, source.keycard_required, source.notes
from (
  values
    (1, 'Lorimer Chapel', 'Lorimer Chapel', 35::numeric, true, true, false, 'Lorimer Chapel: floor-1 elevator door 35 in; separate first-floor approach ~30 in and second-floor approach ~33 in. Doors close ~10 seconds after opening. Serves floors 1–3. Small cabin cannot fit wheelchair user plus assistant. Braille and floor-ding audio signals present. Expired notice photographed (~one year old).'),
    (2, 'Colby College Bookstore', 'Bookstore access elevator (primary wheelchair route to ground-floor bookstore)', 41::numeric, null::boolean, null::boolean, null::boolean, 'Entrance ~3 ft 5 in = 41 in. Doors close ~5 seconds after opening. Other floors serviced not confirmed.')
) as source(source_id, building_name, location_description, door_width_inches, has_braille, has_audio_signals, keycard_required, notes)
join buildings on buildings.name = source.building_name;

insert into elevator_stops (elevator_id, floor_id, building_id)
select elevators.id, floors.id, elevators.building_id
from elevators
join floors on floors.building_id = elevators.building_id
where elevators.source_id = 1 and floors.floor_number in (1, 2, 3);
