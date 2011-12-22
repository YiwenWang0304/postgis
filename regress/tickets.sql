--
-- Regression tests that were filed as cases in bug tickets,
-- referenced by bug number for historical interest.
--

-- NOTE: some tests _require_ spatial_ref_sys entries.
-- In particular, the GML output ones want auth_name and auth_srid too,
-- so we provide one for EPSG:4326
DELETE FROM spatial_ref_sys;
INSERT INTO spatial_ref_sys ( srid, proj4text ) VALUES ( 32611, '+proj=utm +zone=11 +ellps=WGS84 +datum=WGS84 +units=m +no_defs' );
INSERT INTO spatial_ref_sys ( auth_name, auth_srid, srid, proj4text ) VALUES ( 'EPSG', 4326, 4326, '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs' );
INSERT INTO spatial_ref_sys ( srid, proj4text ) VALUES ( 32602, '+proj=utm +zone=2 +ellps=WGS84 +datum=WGS84 +units=m +no_defs ' );
INSERT INTO spatial_ref_sys ( srid, proj4text ) VALUES ( 32702, '+proj=utm +zone=2 +south +ellps=WGS84 +datum=WGS84 +units=m +no_defs ' );
INSERT INTO spatial_ref_sys ( srid, proj4text ) VALUES ( 3395, '+proj=merc +lon_0=0 +k=1 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs ' );


-- #2 --
SELECT '#2', ST_AsText(ST_Union(g)) FROM
( VALUES 
('SRID=4326;MULTIPOLYGON(((1 1,1 2,2 2,2 1,1 1)))'), 
('SRID=4326;MULTIPOLYGON(((2 1,3 1,3 2,2 2,2 1)))')
) AS v(g);

-- #11 --
SELECT '#11', ST_Distance (a.g, ST_Intersection(b.g, a.g)) AS distance 
FROM (SELECT '01020000000200000050E8303FC2E85141B017CFC05A825541000000E0C0E85141000000205C825541'::geometry AS g) a, 
	 (SELECT 'LINESTRING(4694792.35840419 5638508.89950758,4694793.20840419 5638506.34950758)'::geometry AS g) b;
	
-- #21 --
SELECT '#21', ST_AsEWKT(ST_Locate_Along_Measure(g, 4566)) FROM
( VALUES 
(ST_GeomFromEWKT('SRID=31293;LINESTRINGM( 6193.76 5337404.95 4519, 6220.13 5337367.145 4566, 6240.889 5337337.383 4603 )'))
) AS v(g);

-- #22 --
SELECT ST_Within(g, 'POLYGON((0 0,10 0,20 10,10 20,0 20,-10 10,0 0))') FROM 
(VALUES 
('POLYGON((4 9,6 9,6 11,4 11,4 9))')
) AS v(g);

-- #33 --
CREATE TABLE road_pg (ID INTEGER, NAME VARCHAR(32));
SELECT '#33', AddGeometryColumn( '', 'public', 'road_pg','roads_geom', 330000, 'POINT', 2 );
DROP TABLE road_pg;

-- #44 -- 
SELECT '#44', ST_Relate(g1, g2, 'T12101212'), ST_Relate(g1, g2, 't12101212') FROM 
(VALUES 
('POLYGON((0 0, 2 0, 2 2, 0 2, 0 0))', 'POLYGON((1 1, 3 1, 3 3, 1 3, 1 1))')
) AS v(g1, g2);

-- #58 --
SELECT '#58', round(ST_xmin(g)),round(ST_ymin(g)),round(ST_xmax(g)),round(ST_ymax(g)) FROM (SELECT ST_Envelope('CIRCULARSTRING(220268.439465645 150415.359530563,220227.333322076 150505.561285879,220227.353105332 150406.434743975)') as g)  AS foo;

-- #65 --
SELECT '#65', ST_AsGML(ST_GeometryFromText('CURVEPOLYGON(CIRCULARSTRING(4 2,3 -1.0,1 -1,-1.0 4,4 2))'));

-- #66 --
SELECT '#66', ST_AsText((ST_Dump(ST_GeomFromEWKT('CIRCULARSTRING(0 0 1,1 1 2,2 2 3)'))).geom);

-- #68 --
SELECT '#68a', ST_AsText(ST_Shift_Longitude(ST_GeomFromText('MULTIPOINT(1 3, 4 5)')));
SELECT '#68b', ST_AsText(ST_Shift_Longitude(ST_GeomFromText('CIRCULARSTRING(1 3, 4 5, 6 7)')));

-- #69 --
SELECT '#69', ST_AsText(ST_Translate(ST_GeomFromText('CIRCULARSTRING(220268 150415,220227 150505,220227 150406)'),1,2));

-- #70 --
SELECT '#70', ST_NPoints(ST_LinetoCurve(ST_Buffer('POINT(1 2)',3)));

-- #73 --
SELECT '#73', ST_AsText(ST_Force_Collection(ST_GeomFromEWKT('CIRCULARSTRING(1 1 2, 2 3 2, 4 5 2, 6 7 2, 5 6 2)')));

-- #80 --
SELECT '#80', ST_AsText(ST_Multi('MULTILINESTRING((0 0,1 1))'));

-- #83 --
SELECT '#83', ST_AsText(ST_Multi(ST_GeomFromText('CIRCULARSTRING(220268 150415,220227 150505,220227 150406)')));

-- #85 --
SELECT '#85', ST_Distance(ST_GeomFromText('CIRCULARSTRING(220268 150415,220227 150505,220227 150406)'), ST_Point(220268, 150415));

-- #112 --
SELECT '#112', ST_AsText(ST_CurveToLine('GEOMETRYCOLLECTION(POINT(-10 50))'::geometry));

-- #113 --
SELECT '#113', ST_Locate_Along_Measure('LINESTRING(0 0 0, 1 1 1)', 0.5);

-- #116 --
SELECT '#116', ST_AsText('010300000000000000');

-- #122 --
SELECT '#122', ST_AsText(ST_SnapToGrid(ST_GeomFromText('CIRCULARSTRING(220268 150415,220227 150505,220227 150406)'), 0.1));

-- #124 --
SELECT '#124a', ST_AsText(ST_GeomFromEWKT('COMPOUNDCURVE(CIRCULARSTRING(0 0,1 1,1 0),(1 0,30 5),CIRCULARSTRING(30 5,34 56,67 89))'));
SELECT '#124b', ST_AsText(ST_GeomFromEWKT('COMPOUNDCURVE(CIRCULARSTRING(0 0,1 1,1 0),(1 0,30 6),CIRCULARSTRING(30 5,34 56,67 89))'));

-- #145 --
SELECT '#145a', ST_Buffer(ST_GeomFromText('LINESTRING(-116.93414544665981 34.16033385105459,-116.87777514700957 34.10831080544884,-116.86972224705954 34.086748622072776,-116.9327074288116 34.08458099517253,-117.00216369088065 34.130329331330216,-117.00216369088065 34.130329331330216)', 4326), 0);
SELECT '#145b', ST_Area(ST_Buffer(ST_GeomFromText('LINESTRING(-116.93414544665981 34.16033385105459,-116.87777514700957 34.10831080544884,-116.86972224705954 34.086748622072776,-116.9327074288116 34.08458099517253,-117.00216369088065 34.130329331330216,-117.00216369088065 34.130329331330216)', 4326), 0));

-- #146 --
SELECT '#146', ST_Distance(g1,g2), ST_Dwithin(g1,g2,0.01), ST_AsEWKT(g2) FROM (SELECT ST_geomFromEWKT('LINESTRING(1 2, 2 4)') As g1, ST_Collect(ST_GeomFromEWKT('LINESTRING(0 0, -1 -1)'), ST_GeomFromEWKT('MULTIPOINT(1 2,2 3)')) As g2) As foo;

-- #156 --
SELECT '#156', ST_AsEWKT('0106000000010000000103000000010000000700000024213D12AA7BFD40945FF42576511941676A32F9017BFD40B1D67BEA7E511941C3E3C640DB7DFD4026CE38F4EE531941C91289C5A7EFD40017B8518E3531941646F1599AB7DFD409627F1F0AE521941355EBA49547CFD407B14AEC74652194123213D12AA7BFD40945FF42576511941');

-- #157 --
SELECT 
	'#157',
	ST_GeometryType(g) As newname, 
	GeometryType(g) as oldname 
FROM ( VALUES 
	(ST_GeomFromText('POLYGON((-0.25 -1.25,-0.25 1.25,2.5 1.25,2.5 -1.25,-0.25 -1.25), (2.25 0,1.25 1,1.25 -1,2.25 0),(1 -1,1 1,0 0,1 -1))') ),
	( ST_Point(1,2) ), 
	( ST_Buffer(ST_Point(1,2), 3) ), 
	( ST_LineToCurve(ST_Buffer(ST_Point(1,2), 3)) ) , 
	( ST_LineToCurve(ST_Boundary(ST_Buffer(ST_Point(1,2), 3))) )
	) AS v(g);


-- #168 --
SELECT '#168', ST_NPoints(g), ST_AsText(g), ST_isValidReason(g)
FROM ( VALUES
('01060000C00100000001030000C00100000003000000E3D9107E234F5041A3DB66BC97A30F4122ACEF440DAF9440FFFFFFFFFFFFEFFFE3D9107E234F5041A3DB66BC97A30F4122ACEF440DAF9440FFFFFFFFFFFFEFFFE3D9107E234F5041A3DB66BC97A30F4122ACEF440DAF9440FFFFFFFFFFFFEFFF'::geometry)
) AS v(g);

-- #175 --
SELECT '#175', ST_AsEWKT(ST_GeomFromEWKT('SRID=26915;POINT(482020 4984378.)'));

-- #178 --
SELECT '#178a', ST_XMin(ST_MakeBox2D(ST_Point(5, 5), ST_Point(0, 0)));
SELECT '#178b', ST_XMax(ST_MakeBox2D(ST_Point(5, 5), ST_Point(0, 0)));

-- #179 --
SELECT '#179a', ST_MakeLine(ARRAY[NULL,NULL,NULL,NULL]);
SELECT '#179b', ST_MakeLine(ARRAY[NULL,NULL,NULL,NULL]);

-- #183 --
SELECT '#183', ST_AsText(ST_SnapToGrid(ST_LineToCurve(ST_LineMerge(ST_Collect(ST_CurveToLine(ST_GeomFromEWKT('CIRCULARSTRING(0 0, 1 1, 1 0)')),ST_GeomFromEWKT('LINESTRING(1 0, 0 1)') ))), 1E-10));

-- #210 --
SELECT '#210a', ST_Union(ARRAY[NULL,NULL,NULL,NULL]) ;
SELECT '#210b', ST_MakeLine(ARRAY[NULL,NULL,NULL,NULL]) ;

-- #213 --
SELECT '#213', round(ST_Perimeter(ST_CurveToLine(ST_GeomFromEWKT('CURVEPOLYGON(COMPOUNDCURVE(CIRCULARSTRING(0 0,2 0, 2 1, 2 3, 4 3),(4 3, 4 5, 1 4, 0 0)))'))));

-- #234 --
SELECT '#234', ST_AsText(ST_GeomFromText('COMPOUNDCURVE( (0 0,1 1) )'));

-- #239 --
--SELECT '#239', ST_AsSVG('010700002031BF0D0000000000');

-- #241 --
CREATE TABLE c ( the_geom GEOMETRY);
INSERT INTO c SELECT ST_MakeLine(ST_Point(-10,40),ST_Point(40,-10)) As the_geom;
INSERT INTO c SELECT ST_MakeLine(ST_Point(-10,40),ST_Point(40,-10)) As the_geom;
SELECT '#241', sum(ST_LineCrossingDirection(the_geom, ST_GeomFromText('LINESTRING(1 2,3 4)'))) FROM c;
DROP TABLE c;

-- #254 --
SELECT '#254', ST_Segmentize(ST_GeomFromText('GEOMETRYCOLLECTION EMPTY'), 0.5);

-- #259 --
SELECT '#259', ST_Distance(ST_GeographyFromText('SRID=4326;POLYGON EMPTY'), ST_GeographyFromText('SRID=4326;POINT(1 2)'));

-- #260 --
SELECT '#260', round(ST_Distance(ST_GeographyFromText('SRID=4326;POINT(-10 40)'), ST_GeographyFromText('SRID=4326;POINT(-10 55)')));

-- #261 --
SELECT '#261', ST_Distance(ST_GeographyFromText('SRID=4326;POINT(-71.0325022849392 42.3793285830812)'),ST_GeographyFromText('SRID=4326;POLYGON((-71.0325022849392 42.3793285830812,-71.0325745928559 42.3793012556699,-71.0326708728343 42.3794450989722,-71.0326045866257 42.3794706688942,-71.0325022849392 42.3793285830812))'));

-- #262 --
SELECT '#262', ST_AsText(pt.the_geog) As wkt_pt, ST_Covers(poly.the_geog, pt.the_geog) As geog,
	ST_Covers(
		ST_Transform(CAST(poly.the_geog As geometry),32611), 
		ST_Transform(CAST(pt.the_geog As geometry),32611)) As utm,
	ST_Covers(
		CAST(poly.the_geog As geometry), 
		CAST(pt.the_geog As geometry)
	) As pca
FROM (SELECT ST_GeographyFromText('SRID=4326;POLYGON((-119.5434 34.9438,-119.5437 34.9445,-119.5452 34.9442,-119.5434 34.9438))') As the_geog) 
	As poly
    CROSS JOIN 
	(VALUES
		( ST_GeographyFromText('SRID=4326;POINT(-119.5434 34.9438)') ) ,
		( ST_GeographyFromText('SRID=4326;POINT(-119.5452 34.9442)') ) ,
		( ST_GeographyFromText('SRID=4326;POINT(-119.5434 34.9438)') ),
		( ST_GeographyFromText('SRID=4326;POINT(-119.5438 34.9443)')  )
	)
	As pt(the_geog);

-- #263 --
SELECT '#263', ST_AsEWKT(geometry(geography(pt.the_geom))) As wkt,
	ST_Covers(
		ST_Transform(poly.the_geom,32611), 
		ST_Transform(pt.the_geom,32611)) As utm,
	ST_Covers(
		poly.the_geom, 
		pt.the_geom)
	 As pca,
	ST_Covers(geometry(geography(poly.the_geom)),
		geometry(geography(pt.the_geom))) As gm_to_gg_gm_pca
	
FROM (SELECT ST_GeomFromEWKT('SRID=4326;POLYGON((-119.5434 34.9438,-119.5437 34.9445,-119.5452 34.9442,-119.5434 34.9438))') As the_geom) 
	As poly
    CROSS JOIN 
	(VALUES
		( ST_GeomFromEWKT('SRID=4326;POINT(-119.5434 34.9438)') ) ,
		( ST_GeomFromEWKT('SRID=4326;POINT(-119.5452 34.9442)') ) ,
		( ST_GeomFromEWKT('SRID=4326;POINT(-119.5434 34.9438)') ),
		( ST_GeomFromEWKT('SRID=4326;POINT(-119.5438 34.9443)')  )
	)
	As pt(the_geom);

-- #271 --
SELECT '#271', ST_Covers(
'POLYGON((-9.123456789 50,51 -11.123456789,-10.123456789 50,-9.123456789 50))'::geography,
'POINT(-10.123456789 50)'::geography
);

-- #272 --
SELECT '#272', ST_LineCrossingDirection(foo.line1, foo.line2) As l1_cross_l2 ,
    ST_LineCrossingDirection(foo.line2, foo.line1) As l2_cross_l1
FROM (SELECT
    ST_GeomFromText('LINESTRING(25 169,89 114,40 70,86 43)') As line1, ST_GeomFromText('LINESTRING(2.99 90.16,71 74,20 140,171 154)') As line2 ) As foo;

-- #277 --
SELECT '#277', ST_AsGML(2, GeomFromText('POINT(1 1e308)'));

-- #299 --
SELECT '#299', round(ST_Y(geometry(ST_Intersection(ST_GeographyFromText('POINT(1.2456 2)'), ST_GeographyFromText('POINT(1.2456 2)'))))); 

-- #304 --

SELECT '#304';

CREATE OR REPLACE FUNCTION utmzone(geometry)
  RETURNS integer AS
$BODY$
DECLARE
    geomgeog geometry;
    zone int;
    pref int;

BEGIN
    geomgeog:= ST_Transform($1,4326);

    IF (ST_Y(geomgeog))>0 THEN
       pref:=32600;
    ELSE
       pref:=32700;
    END IF;

    zone:=floor((ST_X(geomgeog)+180)/6)+1;

    RETURN zone+pref;
END;
$BODY$ LANGUAGE 'plpgsql' IMMUTABLE
  COST 100;

CREATE TABLE utm_dots ( the_geog geography, utm_srid integer);
INSERT INTO utm_dots SELECT geography(ST_SetSRID(ST_Point(i*10,j*10),4326)) As the_geog, utmzone(ST_SetSRID(ST_Point(i*10,j*10),4326)) As utm_srid FROM generate_series(-17,17) As i CROSS JOIN generate_series(-8,8) As j;

SELECT ST_AsText(the_geog) as the_pt, 
       ST_Area(ST_Buffer(the_geog,10)) As the_area, 
       ST_Area(geography(ST_Transform(ST_Buffer(ST_Transform(geometry(the_geog),utm_srid),10),4326))) As geog_utm_area
FROM utm_dots 
WHERE ST_Area(ST_Buffer(the_geog,10)) NOT between 310 and 314
LIMIT 10;

SELECT '#304.a', Count(*) FROM utm_dots WHERE ST_DWithin(the_geog, 'POINT(0 0)'::geography, 3000000);

CREATE INDEX utm_dots_gix ON utm_dots USING GIST (the_geog);
SELECT '#304.b', Count(*) FROM utm_dots WHERE ST_DWithin(the_geog, 'POINT(0 0)'::geography, 300000);

DROP FUNCTION utmzone(geometry);
DROP TABLE utm_dots;

-- #408 --
SELECT '#408', st_isvalidreason('0105000020E0670000010000000102000020E06700000100000016DA52BA62A04141FFF3AD290B735241');
SELECT '#408.1', st_isvalid('0105000020E0670000010000000102000020E06700000100000016DA52BA62A04141FFF3AD290B735241');
SELECT '#408.2', st_isvalidreason('01020000000100000000000000000000000000000000000000');
SELECT '#408.3', st_isvalid('0106000020BB0B000001000000010300000005000000D6000000000000C0F1A138410AD7A3103190524114AE4721F7A138410000000030905241713D0A57FAA1384185EB51982C9052417B14AE87FAA13841000000402A905241AE47E13AFBA1384114AE474128905241EC51B81EFDA138413D0AD7632690524152B81E85FFA13841D7A3707D2590524152B81E4500A23841713D0A072590524100000000FFA13841713D0AF724905241CDCCCCCCFFA13841CDCCCC0C249052419A99991901A238419A999919249052411F85EBD101A23841D7A3704D23905241E17A14AE02A23841A4703D3A2290524185EB51F808A23841000000D021905241E17A14EE0BA238413333335321905241666666A615A23841B81E85AB1F905241713D0AD710A23841B81E858B1E905241666666260CA2384114AE4731209052410AD7A37009A23841CDCCCCEC20905241AE47E13A06A23841EC51B87E219052419A9999D903A23841EC51B80E21905241EC51B8DE08A238418FC2F5681F905241666666660EA23841A4703D9A1D9052413D0AD7A30FA2384114AE47A11C9052413333333311A23841000000101C90524148E17A1414A23841333333931A905241EC51B81E1AA23841EC51B89E1890524185EB51381CA23841D7A370BD17905241295C8FC220A2384185EB51C816905241C3F528DC2BA238418FC2F5E814905241E17A14EE2EA23841EC51B8FE13905241AE47E1FA2BA23841EC51B8EE119052415C8FC2F52BA2384185EB51C810905241333333332EA2384114AE4701109052417B14AEC73BA238410AD7A3300D905241CDCCCCCC43A238417B14AE870B905241CDCCCC4C45A23841A4703D3A0B9052413D0AD7A34DA238411F85EB810A905241295C8F8250A23841CDCCCCBC09905241000000C053A238410AD7A36009905241A4703D0A5CA2384114AE4751099052418FC2F5A866A23841A4703D4A0A9052410000008069A2384114AE47B10A9052415C8FC2B573A23841B81E851B0D905241AE47E1FA76A23841666666C60D9052417B14AE077BA238411F85EB510E905241AE47E1FA7FA23841666666E60E9052415C8FC2358DA23841000000F010905241EC51B85E95A2384148E17A14119052417B14AE4795A23841CDCCCCCC1090524114AE47E18CA2384185EB51F80F90524148E17AD480A2384114AE47A10E9052413D0AD76383A23841713D0AF70C9052417B14AEC784A23841A4703D8A0C9052410000000086A23841A4703D0A0B9052411F85EB9187A23841B81E851B09905241F6285CCF86A2384100000010099052417B14AE4787A2384185EB51180890524114AE472186A23841CDCCCCFC079052410AD7A3B086A23841C3F5280C07905241333333B385A23841CDCCCC0C07905241000000407EA2384152B81E15079052419A9999197BA23841A4703D2A079052416666666673A2384114AE47710790524114AE47A16EA238413D0AD7F30690524114AE472170A238418FC2F5D8059052413D0AD72372A2384185EB511806905241A4703DCA71A23841D7A3707D05905241EC51B8DE7EA238411F85EBD104905241E17A14AE76A23841333333E30390524185EB51B875A23841713D0A47029052415C8FC2F576A23841D7A3703D029052419A99999976A2384114AE475101905241333333B378A23841EC51B83E019052410AD7A3307CA238410AD7A320019052418FC2F52885A23841295C8FD20090524148E17A9483A238416666664600905241295C8FC276A238411F85EB9100905241CDCCCC4C76A2384100000070FF8F5241AE47E13A76A2384133333343FF8F52417B14AE0783A23841D7A370FDFE8F5241E17A14AE81A23841C3F5283CFE8F52415C8FC2357DA2384114AE47A1FE8F5241CDCCCC8C7BA238415C8FC275FD8F524148E17AD47FA238417B14AE17FD8F5241000000807EA238413D0AD7A3FC8F5241713D0AD776A2384133333363FD8F5241CDCCCC8C73A2384152B81EF5FD8F5241E17A14AE70A2384114AE4711FE8F524185EB51B870A23841B81E852BFF8F524152B81E056CA2384114AE4731FF8F5241B81E856B6BA2384152B81E25FE8F5241AE47E13A69A23841E17A142EFE8F52419A99995962A238415C8FC275FE8F52415C8FC27562A238411F85EB710090524114AE47A15BA23841EC51B86E00905241EC51B85E5BA238419A9999E902905241295C8F025BA238417B14AE8704905241A4703D8A54A23841713D0A7704905241C3F5285C51A2384148E17A44049052418FC2F5E84CA23841A4703D4A049052410AD7A3304CA2384148E17A94049052419A9999994CA238413D0AD7F305905241AE47E1FA49A2384114AE471106905241EC51B85E49A23841AE47E1FA07905241AE47E13A43A238415C8FC255099052416666662644A23841D7A3707D0A9052415C8FC2F53FA23841CDCCCC2C0B90524185EB517839A2384185EB51380C90524152B81E4532A23841D7A370DD099052419A9999592FA2384152B81E4509905241D7A3707D2AA23841B81E857B089052415C8FC27526A238416666667608905241EC51B81E26A238417B14AE7707905241295C8F0226A23841F6285C1F07905241666666A61CA23841CDCCCC6C07905241713D0A1716A23841B81E856B07905241B81E85EB15A2384100000040079052411F85EB1108A2384114AE4741079052415C8FC23505A2384148E17AC40790524152B81E0506A23841EC51B84E09905241713D0A5707A23841AE47E10A0A905241EC51B81E12A2384152B81EA50890524152B81E4521A23841F6285CDF0890524148E17A1427A23841EC51B80E099052415C8FC2B52AA2384185EB5168099052413D0AD7E32FA23841CDCCCC3C0A9052413D0AD7A331A23841333333930A90524185EB51F833A238410AD7A3B00B9052411F85EB5135A23841EC51B8AE0B90524185EB513836A23841333333530D9052410000004030A238415C8FC2B50E905241000000802FA238415C8FC2750E9052410000008028A238419A9999B90E905241F6285C0F28A23841333333630E90524114AE47E123A23841333333730E905241D7A3707D23A2384152B81E750E9052410000008023A2384185EB51E80E905241D7A370BD1EA23841713D0A170F9052419A9999991EA23841333333830F9052419A9999991CA238411F85EB810F90524152B81E450EA2384152B81E750F9052417B14AE470AA23841EC51B89E0F905241B81E85EB05A238410AD7A3F00F905241D7A3707DFFA138417B14AEF71090524185EB51F8FDA138413D0AD72311905241295C8F02FAA13841EC51B83E11905241713D0A17EFA13841E17A145E129052417B14AE87CBA1384152B81E05179052418FC2F528C0A13841D7A3709D17905241D7A370BDC0A13841F6285C5F18905241295C8F82CBA138419A9999F917905241AE47E1BAD7A138415C8FC255169052411F85EB91E0A13841000000401590524114AE47A1E2A1384185EB5108159052415C8FC235ECA13841C3F5286C13905241C3F528DCF4A13841000000701290524152B81E45F5A138415C8FC2A51290524100000040F6A13841CDCCCC7C129052417B14AE47FBA138410000000012905241EC51B85E00A2384185EB51A8119052413D0AD7A305A238419A99990911905241EC51B81E0AA238411F85EB611090524148E17A940EA23841A4703D0A1090524152B81E0514A2384152B81EE50F905241F6285CCF15A238410AD7A3E00F9052417B14AEC718A23841CDCCCCDC0F9052419A9999191AA238415C8FC2E50F905241EC51B81E20A238415C8FC2E50F90524148E17A1420A23841333333C30F9052417B14AE8729A23841713D0AA70F905241000000002AA238413D0AD733119052411F85EB9129A23841C3F528EC12905241E17A142E28A238419A999919149052418FC2F5A825A23841CDCCCC1C15905241C3F5285C21A2384114AE473116905241F6285C4F1BA2384152B81E4517905241D7A3707D1AA2384148E17A1417905241C3F5285C19A23841D7A3702D179052413333333318A23841B81E85CB17905241000000C017A2384185EB5108189052413D0AD72310A238419A9999F91790524148E17A5410A2384148E17AD41690524148E17AD40DA2384152B81ED516905241B81E85AB09A23841F6285C1F179052418FC2F5A809A2384185EB51C8179052418FC2F56808A238417B14AEC7179052410000008008A2384185EB515818905241AE47E1BA16A23841F6285C6F189052410AD7A33017A23841C3F5289C18905241000000C012A23841AE47E10A1A9052411F85EB5110A238413D0AD7131B905241000000800DA238415C8FC2451C90524148E17A140DA23841A4703D4A1C9052413D0AD7230BA2384148E17A141E905241295C8F4205A23841295C8F421E905241F6285C4F00A238419A9999691E905241C3F5289CFDA13841AE47E16A1E905241D7A370FDFDA1384114AE47711F90524185EB51F801A23841B81E855B1F905241A4703D0A05A23841CDCCCCAC1F905241E17A14AE02A23841EC51B89E20905241295C8F82FFA138419A9999E9219052419A999919FEA1384185EB5188239052410AD7A330FAA13841E17A14DE25905241C3F5281CF9A13841F6285CFF26905241AE47E13AF8A138415C8FC2E527905241CDCCCC8CF7A1384185EB51B82890524185EB51F8F7A138413333334329905241C3F5281CF6A138418FC2F5182C905241A4703D4AF5A13841EC51B8BE2C905241CDCCCC0CF4A13841713D0AF72E90524185EB5138F3A13841000000502F905241000000C0F1A138410AD7A3103190524111000000CDCCCC4C6AA23841713D0A170A905241CDCCCC4C6FA238411F85EB710790524148E17A947AA2384114AE47410890524185EB51387BA23841D7A370ED07905241666666267BA23841713D0A7707905241EC51B85E7EA2384114AE476107905241E17A14AE7EA2384114AE473108905241713D0A5785A23841CDCCCCBC089052410AD7A33083A23841F6285C9F0B9052413333337382A23841666666460C90524148E17AD481A23841333333D30C90524114AE472181A23841333333730D905241AE47E1BA7FA23841CDCCCC3C0E9052418FC2F56876A238415C8FC2050D90524185EB513872A238418FC2F5D80B90524185EB513870A23841EC51B82E0B905241CDCCCC4C6AA23841713D0A170A90524113000000A4703DCA6BA238415C8FC295FF8F5241B81E856B74A238410AD7A380FF8F5241EC51B89E74A23841E17A149E00905241AE47E1BA74A23841F6285C4F019052419A99995974A23841295C8F520290524148E17AD473A2384114AE47B10390524152B81EC572A2384114AE4701059052417B14AE476DA23841AE47E1DA04905241F6285C8F6DA23841333333A303905241000000006CA2384152B81E9503905241EC51B81E69A23841A4703D7A039052410AD7A3B068A23841B81E85AB049052415C8FC2F55CA23841CDCCCC8C0490524152B81E455DA238411F85EB0103905241333333B35DA23841AE47E1DA00905241EC51B85E67A23841C3F528FC009052410AD7A3B067A23841CDCCCCCCFF8F524185EB51B86BA23841333333C3FF8F5241A4703DCA6BA238415C8FC295FF8F5241020000003D0AD7A346A238413D0AD7E3099052413D0AD7A346A238413D0AD7E309905241100000007B14AEC74DA238410AD7A3B008905241EC51B85E4EA23841B81E850B079052413D0AD7234FA23841C3F528DC0490524185EB51385CA23841EC51B8EE04905241B81E852B60A23841A4703DDA049052410000008066A23841A4703DFA049052411F85EB116AA23841CDCCCC0C05905241CDCCCC8C6EA23841A4703D5A05905241A4703D0A6CA238417B14AE37079052411F85EBD16AA23841A4703DCA07905241AE47E1FA68A23841E17A14FE08905241295C8F0268A238410AD7A320099052419A99999963A23841AE47E10A099052415C8FC2B55AA23841333333C30890524114AE476156A23841CDCCCCBC089052417B14AEC74DA238410AD7A3B008905241');
SELECT '#408.4', st_isvalidreason('0106000020BB0B000001000000010300000005000000D6000000000000C0F1A138410AD7A3103190524114AE4721F7A138410000000030905241713D0A57FAA1384185EB51982C9052417B14AE87FAA13841000000402A905241AE47E13AFBA1384114AE474128905241EC51B81EFDA138413D0AD7632690524152B81E85FFA13841D7A3707D2590524152B81E4500A23841713D0A072590524100000000FFA13841713D0AF724905241CDCCCCCCFFA13841CDCCCC0C249052419A99991901A238419A999919249052411F85EBD101A23841D7A3704D23905241E17A14AE02A23841A4703D3A2290524185EB51F808A23841000000D021905241E17A14EE0BA238413333335321905241666666A615A23841B81E85AB1F905241713D0AD710A23841B81E858B1E905241666666260CA2384114AE4731209052410AD7A37009A23841CDCCCCEC20905241AE47E13A06A23841EC51B87E219052419A9999D903A23841EC51B80E21905241EC51B8DE08A238418FC2F5681F905241666666660EA23841A4703D9A1D9052413D0AD7A30FA2384114AE47A11C9052413333333311A23841000000101C90524148E17A1414A23841333333931A905241EC51B81E1AA23841EC51B89E1890524185EB51381CA23841D7A370BD17905241295C8FC220A2384185EB51C816905241C3F528DC2BA238418FC2F5E814905241E17A14EE2EA23841EC51B8FE13905241AE47E1FA2BA23841EC51B8EE119052415C8FC2F52BA2384185EB51C810905241333333332EA2384114AE4701109052417B14AEC73BA238410AD7A3300D905241CDCCCCCC43A238417B14AE870B905241CDCCCC4C45A23841A4703D3A0B9052413D0AD7A34DA238411F85EB810A905241295C8F8250A23841CDCCCCBC09905241000000C053A238410AD7A36009905241A4703D0A5CA2384114AE4751099052418FC2F5A866A23841A4703D4A0A9052410000008069A2384114AE47B10A9052415C8FC2B573A23841B81E851B0D905241AE47E1FA76A23841666666C60D9052417B14AE077BA238411F85EB510E905241AE47E1FA7FA23841666666E60E9052415C8FC2358DA23841000000F010905241EC51B85E95A2384148E17A14119052417B14AE4795A23841CDCCCCCC1090524114AE47E18CA2384185EB51F80F90524148E17AD480A2384114AE47A10E9052413D0AD76383A23841713D0AF70C9052417B14AEC784A23841A4703D8A0C9052410000000086A23841A4703D0A0B9052411F85EB9187A23841B81E851B09905241F6285CCF86A2384100000010099052417B14AE4787A2384185EB51180890524114AE472186A23841CDCCCCFC079052410AD7A3B086A23841C3F5280C07905241333333B385A23841CDCCCC0C07905241000000407EA2384152B81E15079052419A9999197BA23841A4703D2A079052416666666673A2384114AE47710790524114AE47A16EA238413D0AD7F30690524114AE472170A238418FC2F5D8059052413D0AD72372A2384185EB511806905241A4703DCA71A23841D7A3707D05905241EC51B8DE7EA238411F85EBD104905241E17A14AE76A23841333333E30390524185EB51B875A23841713D0A47029052415C8FC2F576A23841D7A3703D029052419A99999976A2384114AE475101905241333333B378A23841EC51B83E019052410AD7A3307CA238410AD7A320019052418FC2F52885A23841295C8FD20090524148E17A9483A238416666664600905241295C8FC276A238411F85EB9100905241CDCCCC4C76A2384100000070FF8F5241AE47E13A76A2384133333343FF8F52417B14AE0783A23841D7A370FDFE8F5241E17A14AE81A23841C3F5283CFE8F52415C8FC2357DA2384114AE47A1FE8F5241CDCCCC8C7BA238415C8FC275FD8F524148E17AD47FA238417B14AE17FD8F5241000000807EA238413D0AD7A3FC8F5241713D0AD776A2384133333363FD8F5241CDCCCC8C73A2384152B81EF5FD8F5241E17A14AE70A2384114AE4711FE8F524185EB51B870A23841B81E852BFF8F524152B81E056CA2384114AE4731FF8F5241B81E856B6BA2384152B81E25FE8F5241AE47E13A69A23841E17A142EFE8F52419A99995962A238415C8FC275FE8F52415C8FC27562A238411F85EB710090524114AE47A15BA23841EC51B86E00905241EC51B85E5BA238419A9999E902905241295C8F025BA238417B14AE8704905241A4703D8A54A23841713D0A7704905241C3F5285C51A2384148E17A44049052418FC2F5E84CA23841A4703D4A049052410AD7A3304CA2384148E17A94049052419A9999994CA238413D0AD7F305905241AE47E1FA49A2384114AE471106905241EC51B85E49A23841AE47E1FA07905241AE47E13A43A238415C8FC255099052416666662644A23841D7A3707D0A9052415C8FC2F53FA23841CDCCCC2C0B90524185EB517839A2384185EB51380C90524152B81E4532A23841D7A370DD099052419A9999592FA2384152B81E4509905241D7A3707D2AA23841B81E857B089052415C8FC27526A238416666667608905241EC51B81E26A238417B14AE7707905241295C8F0226A23841F6285C1F07905241666666A61CA23841CDCCCC6C07905241713D0A1716A23841B81E856B07905241B81E85EB15A2384100000040079052411F85EB1108A2384114AE4741079052415C8FC23505A2384148E17AC40790524152B81E0506A23841EC51B84E09905241713D0A5707A23841AE47E10A0A905241EC51B81E12A2384152B81EA50890524152B81E4521A23841F6285CDF0890524148E17A1427A23841EC51B80E099052415C8FC2B52AA2384185EB5168099052413D0AD7E32FA23841CDCCCC3C0A9052413D0AD7A331A23841333333930A90524185EB51F833A238410AD7A3B00B9052411F85EB5135A23841EC51B8AE0B90524185EB513836A23841333333530D9052410000004030A238415C8FC2B50E905241000000802FA238415C8FC2750E9052410000008028A238419A9999B90E905241F6285C0F28A23841333333630E90524114AE47E123A23841333333730E905241D7A3707D23A2384152B81E750E9052410000008023A2384185EB51E80E905241D7A370BD1EA23841713D0A170F9052419A9999991EA23841333333830F9052419A9999991CA238411F85EB810F90524152B81E450EA2384152B81E750F9052417B14AE470AA23841EC51B89E0F905241B81E85EB05A238410AD7A3F00F905241D7A3707DFFA138417B14AEF71090524185EB51F8FDA138413D0AD72311905241295C8F02FAA13841EC51B83E11905241713D0A17EFA13841E17A145E129052417B14AE87CBA1384152B81E05179052418FC2F528C0A13841D7A3709D17905241D7A370BDC0A13841F6285C5F18905241295C8F82CBA138419A9999F917905241AE47E1BAD7A138415C8FC255169052411F85EB91E0A13841000000401590524114AE47A1E2A1384185EB5108159052415C8FC235ECA13841C3F5286C13905241C3F528DCF4A13841000000701290524152B81E45F5A138415C8FC2A51290524100000040F6A13841CDCCCC7C129052417B14AE47FBA138410000000012905241EC51B85E00A2384185EB51A8119052413D0AD7A305A238419A99990911905241EC51B81E0AA238411F85EB611090524148E17A940EA23841A4703D0A1090524152B81E0514A2384152B81EE50F905241F6285CCF15A238410AD7A3E00F9052417B14AEC718A23841CDCCCCDC0F9052419A9999191AA238415C8FC2E50F905241EC51B81E20A238415C8FC2E50F90524148E17A1420A23841333333C30F9052417B14AE8729A23841713D0AA70F905241000000002AA238413D0AD733119052411F85EB9129A23841C3F528EC12905241E17A142E28A238419A999919149052418FC2F5A825A23841CDCCCC1C15905241C3F5285C21A2384114AE473116905241F6285C4F1BA2384152B81E4517905241D7A3707D1AA2384148E17A1417905241C3F5285C19A23841D7A3702D179052413333333318A23841B81E85CB17905241000000C017A2384185EB5108189052413D0AD72310A238419A9999F91790524148E17A5410A2384148E17AD41690524148E17AD40DA2384152B81ED516905241B81E85AB09A23841F6285C1F179052418FC2F5A809A2384185EB51C8179052418FC2F56808A238417B14AEC7179052410000008008A2384185EB515818905241AE47E1BA16A23841F6285C6F189052410AD7A33017A23841C3F5289C18905241000000C012A23841AE47E10A1A9052411F85EB5110A238413D0AD7131B905241000000800DA238415C8FC2451C90524148E17A140DA23841A4703D4A1C9052413D0AD7230BA2384148E17A141E905241295C8F4205A23841295C8F421E905241F6285C4F00A238419A9999691E905241C3F5289CFDA13841AE47E16A1E905241D7A370FDFDA1384114AE47711F90524185EB51F801A23841B81E855B1F905241A4703D0A05A23841CDCCCCAC1F905241E17A14AE02A23841EC51B89E20905241295C8F82FFA138419A9999E9219052419A999919FEA1384185EB5188239052410AD7A330FAA13841E17A14DE25905241C3F5281CF9A13841F6285CFF26905241AE47E13AF8A138415C8FC2E527905241CDCCCC8CF7A1384185EB51B82890524185EB51F8F7A138413333334329905241C3F5281CF6A138418FC2F5182C905241A4703D4AF5A13841EC51B8BE2C905241CDCCCC0CF4A13841713D0AF72E90524185EB5138F3A13841000000502F905241000000C0F1A138410AD7A3103190524111000000CDCCCC4C6AA23841713D0A170A905241CDCCCC4C6FA238411F85EB710790524148E17A947AA2384114AE47410890524185EB51387BA23841D7A370ED07905241666666267BA23841713D0A7707905241EC51B85E7EA2384114AE476107905241E17A14AE7EA2384114AE473108905241713D0A5785A23841CDCCCCBC089052410AD7A33083A23841F6285C9F0B9052413333337382A23841666666460C90524148E17AD481A23841333333D30C90524114AE472181A23841333333730D905241AE47E1BA7FA23841CDCCCC3C0E9052418FC2F56876A238415C8FC2050D90524185EB513872A238418FC2F5D80B90524185EB513870A23841EC51B82E0B905241CDCCCC4C6AA23841713D0A170A90524113000000A4703DCA6BA238415C8FC295FF8F5241B81E856B74A238410AD7A380FF8F5241EC51B89E74A23841E17A149E00905241AE47E1BA74A23841F6285C4F019052419A99995974A23841295C8F520290524148E17AD473A2384114AE47B10390524152B81EC572A2384114AE4701059052417B14AE476DA23841AE47E1DA04905241F6285C8F6DA23841333333A303905241000000006CA2384152B81E9503905241EC51B81E69A23841A4703D7A039052410AD7A3B068A23841B81E85AB049052415C8FC2F55CA23841CDCCCC8C0490524152B81E455DA238411F85EB0103905241333333B35DA23841AE47E1DA00905241EC51B85E67A23841C3F528FC009052410AD7A3B067A23841CDCCCCCCFF8F524185EB51B86BA23841333333C3FF8F5241A4703DCA6BA238415C8FC295FF8F5241020000003D0AD7A346A238413D0AD7E3099052413D0AD7A346A238413D0AD7E309905241100000007B14AEC74DA238410AD7A3B008905241EC51B85E4EA23841B81E850B079052413D0AD7234FA23841C3F528DC0490524185EB51385CA23841EC51B8EE04905241B81E852B60A23841A4703DDA049052410000008066A23841A4703DFA049052411F85EB116AA23841CDCCCC0C05905241CDCCCC8C6EA23841A4703D5A05905241A4703D0A6CA238417B14AE37079052411F85EBD16AA23841A4703DCA07905241AE47E1FA68A23841E17A14FE08905241295C8F0268A238410AD7A320099052419A99999963A23841AE47E10A099052415C8FC2B55AA23841333333C30890524114AE476156A23841CDCCCCBC089052417B14AEC74DA238410AD7A3B008905241');

-- #457 --
SELECT '#457.1', st_astext(st_collectionExtract('POINT(0 0)', 1));
SELECT '#457.2', st_astext(st_collectionExtract('POINT(0 0)', 2));
SELECT '#457.3', st_astext(st_collectionExtract('POINT(0 0)', 3));
SELECT '#457.4', st_astext(st_collectionExtract('LINESTRING(0 0, 1 1)', 1));
SELECT '#457.5', st_astext(st_collectionExtract('LINESTRING(0 0, 1 1)', 2));
SELECT '#457.6', st_astext(st_collectionExtract('LINESTRING(0 0, 1 1)', 3));
SELECT '#457.7', st_astext(st_collectionExtract('POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))', 1));
SELECT '#457.8', st_astext(st_collectionExtract('POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))', 2));
SELECT '#457.9', st_astext(st_collectionExtract('POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))', 3));

-- #650 --
SELECT '#650', ST_AsText(ST_Collect(ARRAY[ST_MakePoint(0,0), ST_MakePoint(1,1), null, ST_MakePoint(2,2)]));

-- #662 --
--SELECT '#662', ST_MakePolygon(ST_AddPoint(ST_AddPoint(ST_MakeLine(ST_SetSRID(ST_MakePointM(i+m,j,m),4326),ST_SetSRID(ST_MakePointM(j+m,i-m,m),4326)),ST_SetSRID(ST_MakePointM(i,j,m),4326)),ST_SetSRID(ST_MakePointM(i+m,j,m),4326))) As the_geom FROM generate_series(-10,50,20) As i CROSS JOIN generate_series(50,70, 20) As j CROSS JOIN generate_series(1,2) As m ORDER BY i, j, m, i*j*m LIMIT 1;

-- #667 --
SELECT '#667', ST_AsEWKT(ST_LineToCurve(ST_Buffer(ST_SetSRID(ST_Point(i,j),4326), j))) As the_geom FROM generate_series(-10,50,10) As i CROSS JOIN generate_series(40,70, 20) As j ORDER BY i, j, i*j LIMIT 1;

-- #677 --
SELECT '#677',round(ST_Distance_Spheroid(ST_GeomFromEWKT('MULTIPOLYGON(((-10 40,-10 55,-10 70,5 40,-10 40)))'), ST_GeomFromEWKT('MULTIPOINT(20 40,20 55,20 70,35 40,35 55,35 70,50 40,50 55,50 70)'), 'SPHEROID["GRS_1980",6378137,298.257222101]')) As result;

-- #680 --
SELECT '#680', encode(ST_AsBinary(geography(foo1.the_geom)),'hex') As result FROM ((SELECT ST_SetSRID(ST_MakePointM(i,j,m),4326) As the_geom FROM generate_series(-10,50,10) As i CROSS JOIN generate_series(50,70, 20) AS j CROSS JOIN generate_series(1,2) As m ORDER BY i, j, i*j*m)) As foo1 LIMIT 1;

-- #682 --
SELECT '#682', ST_Buffer(ST_GeomFromText('POLYGON EMPTY',4326) , 0.5);

-- #683 --
SELECT '#683', ST_BuildArea(ST_GeomFromText('POINT EMPTY',4326));

-- #684 --
SELECT '#684', ST_Centroid(ST_GeomFromText('POLYGON EMPTY',4326));

-- #685 --
SELECT '#685', ST_ConvexHull(ST_GeomFromText('POLYGON EMPTY',4326));

-- #686 --
SELECT '#686', ST_COLLECT(ST_GeomFromText('POLYGON EMPTY',4326),ST_GeomFromText('TRIANGLE EMPTY',4326));

-- #687 --
SELECT '#687', ST_DFullyWithin(ST_GeomFromText('LINESTRING(-10 50,50 -10)',4326), ST_GeomFromText('POLYGON EMPTY',4326),5);

-- #689 --
SELECT '#689', ST_CoveredBy(ST_GeomFromText('POLYGON EMPTY'), ST_GeomFromText('LINESTRING(-10 50,50 -10)'));

-- #690 --
SELECT '#690';
SELECT ST_MakeLine(ST_GeomFromText('POINT(-11.1111111 40)'), ST_GeomFromText('LINESTRING(-11.1111111 70,70 -11.1111111)')) As result;

-- #693 --
SELECT '#693a', ST_GeomFromEWKT('SRID=4326;POLYGONM((-71.1319 42.2503 1,-71.132 42.2502 3,-71.1323 42.2504 -2,-71.1322 42.2505 1,-71.1319 42.2503 0))');
SELECT '#693b', ST_GeomFromEWKT('SRID=4326;POLYGONM((-71.1319 42.2512 0,-71.1318 42.2511 20,-71.1317 42.2511 -20,-71.1317 42.251 5,-71.1317 42.2509 4,-71.132 42.2511 6,-71.1319 42.2512 30))');

-- #694 --
SELECT '#694';
SELECT ST_MakePolygon('POINT(1 2)'::geometry);

-- #695 --
SELECT '#695';
SELECT ST_RemovePoint('POINT(-11.1111111 40)'::geometry, 1);

-- #696 --
SELECT '#696',ST_Segmentize(ST_GeomFromEWKT('PolyhedralSurface( ((0 0 0, 0 0 1, 0 1 1, 0 1 0, 0 0 0)), ((0 0 0, 0 1 0, 1 1 0, 1 0 0, 0 0 0)), ((0 0 0, 1 0 0, 1 0 1, 0 0 1, 0 0 0)), ((1 1 0, 1 1 1, 1 0 1, 1 0 0, 1 1 0)), ((0 1 0, 0 1 1, 1 1 1, 1 1 0, 0 1 0)), ((0 0 1, 1 0 1, 1 1 1, 0 1 1, 0 0 1)) )'), 0.5);

-- #720 --
SELECT '#720', ST_AsText(ST_SnapTogrid(ST_Transform(ST_GeomFromText('MULTIPOINT(-10 40,-10 55,-10 70,5 40,5 55,5 70,20 40,20 55,20 70,35 40,35 55,35 70,50 40,50 55,50 70)',4326), 3395), 0.01));

-- #723 --
SELECT '#723',ST_Intersection(a.geog, b.geog) As result FROM (VALUES (ST_GeogFromText('SRID=4326;POINT(-11.1111111 40)') ), (ST_GeogFromText('SRID=4326;POINT(-11.1111111 55)') ) ) As  a(geog) CROSS JOIN ( VALUES (ST_GeogFromText('SRID=4326;POINT(-11.1111111 40)') ), (ST_GeogFromText('SRID=4326;POINT(-11.1111111 55)') )) As b(geog);	

-- #729 --
--SELECT '#729',ST_MakeLine(foo1.the_geom) As result FROM ((SELECT ST_GeomFromText('POINT EMPTY',4326) As the_geom UNION ALL SELECT ST_GeomFromText('MULTIPOINT EMPTY',4326) As the_geom UNION ALL SELECT ST_GeomFromText('MULTIPOLYGON EMPTY',4326) As the_geom UNION ALL SELECT ST_GeomFromText('LINESTRING EMPTY',4326) As the_geom UNION ALL SELECT ST_GeomFromText('MULTILINESTRING EMPTY',4326) As the_geom ) ) As foo1;

-- #804
SELECT '#804', ST_AsGML(3, 'SRID=4326;POINT(0 0)'::geometry, 0, 1);


-- #845
SELECT '#845', ST_Intersects('POINT(169.69960846592 -46.5061209281002)'::geometry, 'POLYGON((169.699607857174 -46.5061218662,169.699607857174 -46.5061195965597,169.699608806526 -46.5061195965597,169.699608806526 -46.5061218662,169.699607857174 -46.5061218662))'::geometry);

-- #834
SELECT '#834', ST_AsEWKT(ST_Intersection('LINESTRING(0 0,0 10,10 10,10 0)', 'LINESTRING(10 10 4,10 0 5,0 0 5)'));

-- #884 --
CREATE TABLE foo (id integer, the_geom geometry);
INSERT INTO foo VALUES (1, st_geomfromtext('MULTIPOLYGON(((-113.6 35.4,-113.6 35.8,-113.2 35.8,-113.2 35.4,-113.6 35.4),(-113.5 35.5,-113.3 35.5,-113.3 35.7,-113.5 35.7,-113.5 35.5)))'));
INSERT INTO foo VALUES (2, st_geomfromtext('MULTIPOLYGON(((-113.7 35.3,-113.7 35.9,-113.1 35.9,-113.1 35.3,-113.7 35.3),(-113.6 35.4,-113.2 35.4,-113.2 35.8,-113.6 35.8,-113.6 35.4)),((-113.5 35.5,-113.5 35.7,-113.3 35.7,-113.3 35.5,-113.5 35.5)))'));

select '#884', id, ST_Within(
ST_GeomFromText('POINT (-113.4 35.6)'), the_geom
) from foo;

select '#938', 'POLYGON EMPTY'::geometry::box2d;

DROP TABLE foo;

-- #668 --
select '#668',box2d('CIRCULARSTRING(10 2,12 2,14 2)'::geometry) as b;

-- #711 --
select '#711', ST_GeoHash(ST_GeomFromText('POLYGON EMPTY',4326));

-- #712 --
SELECT '#712',ST_IsValid(ST_GeomFromText('POLYGON EMPTY',4326));

-- #756
WITH inp AS ( SELECT 'LINESTRING(0 0, 1 1)'::geometry as s,
                     'LINESTRING EMPTY'::geometry as e      )
 SELECT '#756.1', ST_Equals(s, st_multi(s)),
                  ST_Equals(s, st_collect(s, e))
 FROM inp;


-- #1023 --
select '#1023', 'POINT(10 4)'::geometry = 'POINT(10 4)'::geometry;
select '#1023.a', 'POINT(10 4)'::geometry = 'POINT(10 5)'::geometry;
select '#1023.b', postgis_addbbox('POINT(10 4)'::geometry) = 'POINT(10 4)'::geometry;

-- #1069 --
select '#1060', ST_Relate(ST_GeomFromText('POINT EMPTY',4326), ST_GeomFromText('POINT EMPTY',4326)) As result;

-- #1273 --
WITH p AS ( SELECT 'POINT(832694.188 816254.625)'::geometry as g ) 
SELECT '#1273', st_equals(p.g, postgis_addbbox(p.g)) from p;

-- Another for #1273 --
WITH p AS ( SELECT 'MULTIPOINT((832694.188 816254.625))'::geometry as g ) 
SELECT '#1273.1', st_equals(p.g, postgis_dropbbox(p.g)) from p;

-- #877
create table t(g geometry);
select '#877.1', st_estimated_extent('t','g');
analyze t;
select '#877.2', st_estimated_extent('public', 't','g');
insert into t(g) values ('LINESTRING(-10 -50, 20 30)');
select '#877.3', st_estimated_extent('t','g');
analyze t;
select '#877.4', st_estimated_extent('t','g');
drop table t;

-- #1320
SELECT '<#1320>';
CREATE TABLE A ( geom geometry(MultiPolygon, 4326),
                 geog geography(MultiPolygon, 4326) );
-- Valid inserts
INSERT INTO a(geog) VALUES('SRID=4326;MULTIPOLYGON (((0 0, 10 0, 10 10, 0 0)))'::geography);
INSERT INTO a(geom) VALUES('SRID=4326;MULTIPOLYGON (((0 0, 10 0, 10 10, 0 0)))'::geometry);
SELECT '#1320.geog.1', geometrytype(geog::geometry), st_srid(geog::geometry) FROM a where geog is not null;
SELECT '#1320.geom.1', geometrytype(geom), st_srid(geom) FROM a where geom is not null;
-- Type mismatches is not allowed
INSERT INTO a(geog) VALUES('SRID=4326;POLYGON ((0 0, 10 0, 10 10, 0 0))'::geography);
INSERT INTO a(geom) VALUES('SRID=4326;POLYGON ((0 0, 10 0, 10 10, 0 0))'::geometry);
SELECT '#1320.geog.2', geometrytype(geog::geometry), st_srid(geog::geometry) FROM a where geog is not null;
SELECT '#1320.geom.2', geometrytype(geom), st_srid(geom) FROM a where geom is not null;
-- Even if it's a trigger changing the type
CREATE OR REPLACE FUNCTION triga() RETURNS trigger AS
$$ BEGIN
	NEW.geom = ST_GeometryN(New.geom,1);
	NEW.geog = ST_GeometryN(New.geog::geometry,1)::geography;
	RETURN NEW;
END; $$ language plpgsql VOLATILE;
CREATE TRIGGER triga_before
  BEFORE INSERT ON a FOR EACH ROW
  EXECUTE PROCEDURE triga();
INSERT INTO a(geog) VALUES('SRID=4326;MULTIPOLYGON (((0 0, 10 0, 10 10, 0 0)))'::geography);
INSERT INTO a(geom) VALUES('SRID=4326;MULTIPOLYGON (((0 0, 10 0, 10 10, 0 0)))'::geometry);
SELECT '#1320.geog.3', geometrytype(geog::geometry), st_srid(geog::geometry) FROM a where geog is not null;
SELECT '#1320.geom.3', geometrytype(geom), st_srid(geom) FROM a where geom is not null;
DROP TABLE A;
DROP FUNCTION triga();
SELECT '</#1320>';

-- st_AsText POLYGON((0 0,10 0,10 10,0 0))


-- #1344
select '#1344', octet_length(ST_AsEWKB(st_makeline(g))) FROM ( values ('POINT(0 0)'::geometry ) ) as foo(g);

-- #1385
SELECT '#1385', ST_Extent(g) FROM ( select null::geometry as g ) as foo; 

-- Clean up
DELETE FROM spatial_ref_sys;

