--6/24/2023
--crear la extension para el Universal Unique Identifier
create extension if not exists "uuid-ossp";

--para encriptar datos 
CREATE EXTENSION pgcrypto;

select * from roles r ;
--para verificar si se esta ejecutando el Universal Unique Identifier 
select uuid_generate_v1() as xd;

--crear tabla Usuario 
create table usuario(
	ID_User uuid default uuid_generate_V4(),
	Nombres varchar(200) not null ,
	Tipo_identificacion varchar(50) not null,
	Identificacion Varchar(15) not null,
	Correo_personal varchar(100) not null,
	Correo_Institucional varchar(100) not null,
	Numero_celular varchar(15) not null,
	Estado bool Default true not null,
	URL_Foto varchar(500) not null,
	IsAdmin bool Default false not null,
		Primary Key(ID_User)
);
--Añadir unique a los correos, cedula, celular, Nombres
select * from usuario u 
delete from usuario u where id_user = 'd1e761cc-0d1c-4467-9056-04a4acfa5dcb';
update area_departamental  set logo_url= '/img/Home/logo-fci-1.jpg' where id_area = 1
update usuario  set Tipo_Identificacion = 'Cedula' where id_user = 'c09cda3f-0346-4243-8e59-82d8741e32b1';
update usuario  set Tipo_Identificacion = 'Cedula' where id_user = '99d94b7e-f96e-48bc-9c6e-443a19872e02';

update usuario  set Tipo_Identificacion = 'Cedula' where id_user = '99d94b7e-f96e-48bc-9c6e-443a19872e02';
update usuario  set Numero_Celular = '0997669756' where id_user = 'c09cda3f-0346-4243-8e59-82d8741e32b1';
update usuario  set Numero_Celular = '0997669758' where id_user = '99d94b7e-f96e-48bc-9c6e-443a19872e02';

delete from usuario  where id_user = '9f66409a-e7e1-410f-aa1d-5334ae39e288'

update usuario set url_foto = '../../uploads/perfiles/logo-fci-1-1688335834767.jpg' where id_user = 'c09cda3f-0346-4243-8e59-82d8741e32b1';
update usuario set url_foto = '../../uploads/perfiles/logo-fci-1-1688335834767.jpg' where id_user = '99d94b7e-f96e-48bc-9c6e-443a19872e02';
update usuario set url_foto = '../../uploads/perfiles/logo-fci-1-1688335834767.jpg' where id_user = '2865e766-3a30-48c1-a353-089dda4734fb';
update usuario set url_foto = '../../uploads/perfiles/logo-fci-1-1688335834767.jpg' where id_user = '3782b130-8aea-415b-b60f-b32e31b12d5e';
update usuario set url_foto = '../../uploads/perfiles/logo-fci-1-1688335834767.jpg' where id_user = '171665c0-9946-48d5-9f41-d196dea3e557';
update usuario set url_foto = '../../uploads/perfiles/logo-fci-1-1688335834767.jpg' where id_user = 'c9ee1303-2726-4b26-8e44-d6843f8453eb';
update usuario set url_foto = '../../uploads/perfiles/logo-fci-1-1688335834767.jpg' where id_user = 'e4115e23-011d-49e0-a22f-8f105560a135';
update usuario set url_foto = '../../uploads/perfiles/logo-fci-1-1688335834767.jpg' where id_user = '3eb11479-d968-4f57-bc05-b9de9ca87bf2';
update usuario set url_foto = '../../uploads/perfiles/logo-fci-1-1688335834767.jpg' where id_user = 'cf611e4a-d024-467b-884d-2856a86bc711';


---funcion para retornar la direccion de la imagen de perfil del usuario xd 

create or replace function User_Perfil(idu varchar(500))
returns table
(
	Url_foto_User varchar(800)
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select url_foto  from usuario where cast(id_user as varchar(500))=idu;
end;
$BODY$

select * from User_Perfil('0ffe7d2c-779b-41ac-9186-4ca196edb230');





update  usuario set Numero_celular='0997669755' where id_user = 'e4115e23-011d-49e0-a22f-8f105560a135';
--Nombres
alter table usuario
  add constraint UQ_Name
  unique (nombres);
 --Identificacion
alter table usuario
  add constraint UQ_Identificacion
  unique (Identificacion);
 
 select * from usuario u 
 
 alter table usuario
  add constraint UQ_Firma
  unique (nombre_firma);
  --Identificacion
alter table usuario
  add constraint UQ_T_Identificacion
  unique (Tipo_identificacion);
  --Identificacion
alter table usuario
  add constraint UQ_Correo_personal
  unique (Correo_personal);
   --Identificacion
alter table usuario
  add constraint Correo_Institucional
  unique (Correo_Institucional);
    --Identificacion
alter table usuario
  add constraint UQ_Numero_celular
  unique (Numero_celular);
 
 --añadir not null a los campos xd 
 alter table usuario alter column nombres set not null;
 alter table usuario alter column Identificacion set not null;
 alter table usuario alter column Tipo_identificacion set not null;
 alter table usuario alter column Correo_personal set not null;
 alter table usuario alter column Correo_Institucional set not null;
 alter table usuario alter column Numero_celular set not null;
 alter table usuario alter column nombre_firma set not null;
 alter table usuario alter column contra set not null;

alter table usuario  alter column url_foto set default '../../uploads/perfiles/user.png';

--Checks Constraints para que el tipo de identificacion solo sea 'Cedula', 'Pasaporte', 'Ruc'
ALTER TABLE usuario 
ADD CONSTRAINT CK_Tipo_Identifi
CHECK (
	Tipo_identificacion = 'Cedula' or Tipo_identificacion = 'Ruc' or Tipo_identificacion= 'Pasaporte'
);




--Procedimiento almacenado para crear un usuario admin o normal xd
--Cuando se cree un usuario su contrasena sera su numero de identificacion
Create or Replace Procedure Crear_Usuario(p_nombres varchar(200),
										  p_tipo_identificacion varchar(50),
										  p_identificacion varchar(15),
										  p_correo1 varchar(100),
										  p_correo2 varchar(100),
							  			  p_celular varchar(15),
										  p_foto varchar(500),
										  p_firma varchar(100),
										  p_isadmin bool)
Language 'plpgsql'
AS $$
Begin

if(p_isadmin)
then
	insert into usuario (nombres,tipo_identificacion,identificacion,correo_personal,correo_institucional,numero_celular,url_foto,isadmin,Nombre_firma,Contra)values
	(p_nombres, p_tipo_identificacion,p_identificacion,p_correo1,p_correo2,p_celular,p_foto,p_isadmin,p_firma,PGP_SYM_ENCRYPT(p_identificacion,'SGDV_KEY'));
else
insert into usuario (nombres,tipo_identificacion,identificacion,correo_personal,correo_institucional,numero_celular,url_foto,Nombre_firma,Contra)values
	(p_nombres, p_tipo_identificacion,p_identificacion,p_correo1,p_correo2,p_celular,p_foto,p_firma,PGP_SYM_ENCRYPT(p_identificacion,'SGDV_KEY'));
end if;

COMMIT;
END;
$$;


--Llamar Procedimiento Almacenado para crear un usuario administrador
call
 Crear_Usuario('Raul','cedula','12233','correo1','correo2','asasdas','urlfoto','firmaRaul',TRUE);
 
 --anadir columna para el nombre de la firma
 --ALTER TABLE table_name ADD COLUMN new_column_name data_type constraint;
 
alter table usuario 
add column Nombre_firma varchar(100);

--agregar campo contrasena
alter table usuario 
add column Contra varchar(500);

--desencriptar la contrasena para poder verla  pgp_sym_decrypt(password::bytea,'SGDV_KEY')
--hacer un update en un campo encriptado  password=(PGP_SYM_ENCRYPT('newpassword', 'AES_KEY'));
--comparar contrasenas para el login PGP_SYM_DECRYPT(password::bytea, 'AES_KEY') = 'newpassword';
 delete from usuario;
 select * from usuario;
 
select PGP_SYM_DECRYPT(contra ::bytea, 'SGDV_KEY'),* from usuario u 
--Proceso almacenado para iniciar sesion

select * from usuario u where u.correo_institucional = ''or '1' ='1'



Create or Replace Procedure Auth_Verification(email varchar(200),
										  contra1 varchar(200),INOUT verification bool DEFAULT NULL)
Language 'plpgsql'
AS $$
Begin

select  verification case when COUNT(*)=1 then true else false end from usuario u where correo_institucional  = email and  PGP_SYM_DECRYPT(contra ::bytea, 'SGDV_KEY') = contra1;

COMMIT;
END;
$$;

select PGP_SYM_DECRYPT(u.contra ::bytea, 'SGDV_KEY'),u.correo_institucional  from usuario u ; 


--se tendria que enviar tres posibles estados 
-- 1 .- El login es correcto 
-- 2 .- Las credenciales son incorrectas.
-- 3 .- El usuario tiene deshabilitado el inincio de sesion
-- 4.- Este estado corresponde a cuando se quiera logear con un usuario que no existe
--- puedo enviar el verficiador y el mensaje para que lo procese el frontend 
--Funcion para iniciar sesion


DROP FUNCTION verification_auth(character varying,character varying);


create or replace function Verification_Auth(email varchar(200),
										  contra1 varchar(200))
returns table
(
	verification int, mensaje  character varying
)
language 'plpgsql'
as
$BODY$
declare
	User_Deshabili bool;
	User_Exit bool;
begin
	--Primero Verificar si el correo que se esta ingresando existe
	select into User_Exit case when COUNT(*)>=1 then True else false end  from usuario where correo_institucional=email;	
	--Segundo  Verificar si el usuario tiene un estado habilitado o deshabilitado
	if (User_Exit) then 
		select into User_Deshabili estado from usuario where correo_institucional=email;
		if (User_Deshabili) then 
			return query
			select
			cast(case when COUNT(*)>=1 then 1 else 2 end as int),
			 cast(case when COUNT(*)>=1 then 'Login Correcto' else 'Contraseña incorrecta' end as varchar(500))
			from usuario
			where correo_institucional  = email 
			and  PGP_SYM_DECRYPT(contra ::bytea, 'SGDV_KEY') = contra1
   			and estado=true;
   		else 
   			return query
			select cast(3 as int), cast('Usuario deshabilitado contacte con un administrador' as varchar(500));
		end if;
	else 
	   		return query
			select cast(4 as int), cast('Este correo no esta registrado' as varchar(500));
	end if;
end;
$BODY$


	select 3, 'character varying'
		from usuario where correo_institucional='rcoelloc2@uteq.edu.ec';
	
	
--Probar la funcion que retorna una tabla con el valor en bool
	
--Primer caso Login inexistente 
select Verification_Auth('Raul','Raul');
--Segundo Caso Contraseña incorrecta
select Verification_Auth('rcoelloc2@uteq.edu.ec','Raul1');
--Tercer caso usuario deshabilitado
select Verification_Auth('rcoelloc222@uteq.edu.ec','0908070605');
--Cuarto Caso Login correcto 
select Verification_Auth('rcoelloc2@uteq.edu.ec','Raul');




--Obtener el id del usuario para almacenarlo en una cookie y si es un usuario administrador general 
create or replace function Auth_Data(email varchar(200),
										  contra1 varchar(200))
returns table
(
	UserD varchar(500),verification bool
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select cast(ID_User as varchar(500)) as UserT,IsAdmin as AdminS  from usuario where correo_institucional  = email and  PGP_SYM_DECRYPT(contra ::bytea, 'SGDV_KEY') = contra1;
end;
$BODY$

--Probar la funcion que retorna los valores del auth user
select  * from Auth_Data('Raul','Raul'); 

select cast(ID_User as varchar(500)) as UserT,IsAdmin as AdminS  from usuario where correo_institucional  = 'Raul' and  PGP_SYM_DECRYPT(contra ::bytea, 'SGDV_KEY') = 'Raul';


select * from usuario u where id_user = 'c09cda3f-0346-4243-8e59-82d8741e32b1'

select * from usuario u 
delete from usuario  where id_user = '7a7300d5-b23c-4ffd-98be-e0613516cf30'


--Funcion para obtener los datos del usuario por su ID menos la contrasena obviamente xd 
select nombres,tipo_identificacion ,identificacion ,correo_personal ,correo_institucional,numero_celular ,estado ,url_foto ,nombre_firma ,isadmin  from usuario u;

select * from usuario u2 ;
create or replace function User_Data(idu varchar(500))
returns table
(
	Nombres_User varchar(100), Tip_Iden varchar(100), Identi varchar(100), Correo_personal_User varchar(100), Correo_Institucional_User varchar(100), Numero_celular_User varchar(100), Estado_User bool, 
	Url_foto_User varchar(100), Nombre_firma_User varchar(100), IsAdmin_User bool
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select nombres,tipo_identificacion ,identificacion ,correo_personal ,correo_institucional,numero_celular ,estado ,url_foto ,nombre_firma ,isadmin  from usuario where cast(id_user as varchar(500))=idu;
end;
$BODY$

select * from User_Data('c09cda3f-0346-4243-8e59-82d8741e32b1');
select * from usuario u ;

//hacer que usuario normal se convierta en SU 
update usuario set isadmin = true where cast(id_user as varchar(500))='c09cda3f-0346-4243-8e59-82d8741e32b1';

--Funcion que retorna todos los datos de todos los usuarios menos la contrasena xd 
DROP FUNCTION users_alldata();

create or replace function Users_allData()
returns table
(
	UserID varchar(100),Nombres_User varchar(100), Tip_Iden varchar(100), Identi varchar(100), Correo_personal_User varchar(100), Correo_Institucional_User varchar(100), Numero_celular_User varchar(100), Estado_User bool, 
	Url_foto_User varchar(100), Nombre_firma_User varchar(100), IsAdmin_User bool, EstadoU  varchar(50)
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select cast(id_user as varchar(500)) as UsuarioID,nombres,tipo_identificacion ,identificacion ,correo_personal ,correo_institucional,numero_celular ,estado ,url_foto ,nombre_firma ,isadmin, 
	cast (case when estado then 'Habilitado' else 'Deshabilitado' end as varchar(50)) 
	from usuario;
end;
$BODY$

select * from Users_allData();

--Poner una imagen default para los usuarios en caso no ingresar una imagen xd 
--alter table alerts alter column bisactive set default 1;

alter table usuario alter column url_foto set default '/img/Home/photo-1633332755192-727a05c4013d.jpg';

--crear tabla para las areas 
create table area_departamental(
	Id_area INT GENERATED ALWAYS AS IDENTITY,
	nombre_area varchar(200) not null ,
	fecha_creacion TIMESTAMPTZ DEFAULT Now(),
	estado bool not null,
	id_nivel int not null,
	logo_url varchar(500) not null,
		Primary Key(Id_area)
);

--crear tabla para los niveles de las areas 
create table niveles_areas(
	Id_nivel int generated always as identity,
	fecha_creacion date,
	descripcion varchar(255),
	nivel int,
	primary Key(Id_nivel)
);

--crear tabla para relacionar los usuarios con las areas
create table usuarios_areas(
	Id_relacion int generated always as identity,
	Id_usuario uuid,
	Id_area int not null,
	fecha_creacion TIMESTAMPTZ DEFAULT Now(),
	estado bool not null,
	id_rol int,
	primary key(Id_relacion)
);

alter table area_departamental alter column estado set default true;

select * from area_departamental;
select * from niveles_areas na ;
--proceso almacenado para crear las areas 
Create or Replace Procedure crear_area_padre(p_nombres varchar(200),
										p_logo_area varchar(500))
Language 'plpgsql'
AS $$
Begin

	insert into area_departamental(nombre_area,logo_url)values
	(p_nombres,p_logo_area);
COMMIT;
END;
$$;

--Seleccionar fecha 
SELECT NOW();

call crear_area('Area1',1,'/url/');


select * from area_departamental ad ;

--funcion que retorna todas las areas con toda su info 
drop function area_allData();
create or replace function area_allData()
returns table
(
	Area_id int, NombreArea varchar(200), EstadoArea bool, LogoArea varchar(500), Prefijo varchar(5)
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select ad.id_area, ad.nombre_area, ad.estado,ad.logo_url, ad.prefijo_departamento from area_departamental ad;
end;
$BODY$

select * from area_allData();

update area_departamental  set logo_url= '/img/Home/logo-fci-1.jpg' where id_area = 1

drop table usuarios_areas;
--Conectar las primary key con las foreing key de usuarios y areas con la tabla transaccional usuarios_areas
--alter table INProductos add constraint CategoIN FOREIGN KEY (CodCategoria) references INCategoria(CodCategoria);

alter table usuarios_areas add constraint id_area foreign key (id_area) references area_departamental(id_area);
alter table usuarios_areas add constraint id_usuario foreign key (id_usuario) references usuario(id_user);

alter table usuarios_areas alter column estado set default true;

--Procedimiento almacenado para conectar usuarios con areas 
Create or Replace procedure usuarios_areas(p_id_user varchar(200),
										p_id_area varchar(100)
										)
Language 'plpgsql'
AS $$
Begin

	insert into usuarios_areas (id_usuario, id_area)values
	(cast(p_id_user as uuid),cast(p_id_area as int));

COMMIT;
END;
$$;

select * from usuario u ;
select * from area_departamental ad;
select * from usuarios_areas ua ;
 
delete from usuarios_areas where id_relacion = 2;
call usuarios_areas('c09cda3f-0346-4243-8e59-82d8741e32b1', 6, 1) 


--funcion que liste los usuarios de una area 
select u.url_foto ,u.nombres ,u.correo_personal ,u.correo_institucional ,u.id_user ,
u.nombre_firma ,u.numero_celular ,u.identificacion 
from usuarios_areas ua 
inner join usuario u on ua.id_usuario =u.id_user 
inner join area_departamental ad on ua.id_area =ad.id_area 
where u.estado =true and ad.id_area =6 ;

select * from usuarios_areas ua 
DROP FUNCTION user_area(integer)
create or replace function user_area(p_id_area int)
returns table
(
	U_foto varchar(500), U_nombres varchar(500), U_Correo varchar(500), U_Correo2 varchar(500),
	U_Id_User varchar(500),U_nombreFirma  varchar(500), U_celular  varchar(500), U_Identificacion  varchar(500),
	U_Rol  varchar(500), U_relacion int
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select u.url_foto ,u.nombres ,u.correo_personal ,u.correo_institucional ,cast(u.id_user as varchar(500)) ,
u.nombre_firma ,u.numero_celular ,u.identificacion , case when ua.rol_area then cast('Administrador Area' as Varchar(500)) else cast('Usuario Normal'as varchar(500)) end,
ua.id_relacion 
from usuarios_areas ua 
inner join usuario u on ua.id_usuario =u.id_user 
inner join area_departamental ad on ua.id_area =ad.id_area 
where ua.estado =true and ad.id_area =p_id_area and u.estado =true ;
end;
$BODY$

select * from user_area(6);

--listar usuarios que no tienen area asignada
select * from usuario u ;
select * from usuarios_areas ua where id_relacion = 143;

delete from usuarios_areas where id_relacion=3;
delete from usuarios_areas where id_relacion=20;
delete from usuarios_areas where id_relacion=21;
delete from usuarios_areas where id_relacion=22;
delete from usuarios_areas where id_relacion=23;
delete from usuarios_areas where id_relacion=24;


create or replace function user_sin_area()
returns table
(
	U_foto varchar(500), U_nombres varchar(500), U_Correo varchar(500), U_Correo2 varchar(500),
	U_Id_User varchar(500), U_Identificacion  varchar(500)
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select u.url_foto,u.nombres ,u.correo_personal ,u.correo_institucional ,cast(u.id_user as varchar(500)) ,u.identificacion 
from usuario u  left join usuarios_areas ua on u.id_user =ua.id_usuario where ua.id_usuario isnull and u.estado =true  ;

end;
$BODY$

select * from user_sin_area();

select u.url_foto,u.nombres ,u.correo_personal ,u.correo_institucional ,u.id_user ,u.identificacion  from usuario u  left join usuarios_areas ua on u.id_user =ua.id_usuario where ua.id_usuario isnull and u.estado =true  ;


	select u.url_foto,u.nombres ,u.correo_personal ,u.correo_institucional ,cast(u.id_user as varchar(500)) ,u.identificacion, ad.nombre_area 
from usuario u  inner join usuarios_areas ua on u.id_user =ua.id_usuario  inner join area_departamental ad on ua.id_area = ad.id_area

--crear tabla roles 

create table roles(
	Id_rol int generated always as identity,
	Rol varchar(500) not null,
	Descripcion varchar(500) not null,
	fecha_creacion TIMESTAMPTZ DEFAULT Now(),
	estado bool not null,
	primary key(Id_rol)
);

--Establecer un default y conectar con la tabla usuarios roles
alter table roles alter column estado set default true;
alter table usuarios_areas add constraint id_rol foreign key (id_rol) references roles(id_rol);

select id_rol ,rol ,descripcion  from roles where estado =true ;
select * from usuarios_areas ua ;
delete from usuarios_areas ;

--crear roles desde la bd 
insert into roles (rol,descripcion) values ('Admin','Administra toda el area a la que pertenece');
insert into roles (rol,descripcion) values ('Revisor','Solo puede ver documentos no editarlos');
insert into roles (rol,descripcion) values ('Editor','Edita documentos y participa en la creacion');

--funcion que retorne los roles que existen 
create or replace function all_roles()
returns table
(
	R_id int, R_rol varchar(100), R_descripcion varchar(500)
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select id_rol ,rol ,descripcion  from roles where estado =true ;
end;
$BODY$

select * from all_roles();
select * from area_departamental ad ;
select * from user_area(2);

select * from usuarios_areas ua2 ;
select r.rol  from usuarios_areas ua inner join usuario u on ua.id_usuario =u.id_user  inner join roles r on ua.id_rol =r.id_rol ;

--funcion para retornar el area a la que pertenece un usuario y si es admin retornar un true para mostrar la op en el menu
select 
ad.id_area , r.rol , case when r.rol = 'Admin' then true else false end as Isadmin
from usuarios_areas ua 
inner join usuario u on ua.id_usuario =u.id_user 
inner join area_departamental ad on ua.id_area =ad.id_area 
inner join roles r on ua.id_rol =r.id_rol
where ua.estado = true and cast(u.id_user as varchar(500)) = '2865e766-3a30-48c1-a353-089dda4734fb' 


create or replace function data_user_area(p_id_user varchar(500))
returns table
(
	r_id_area int, r_rol varchar(100), r_isadmin_area bool
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select 
	ad.id_area , r.rol , case when r.rol = 'Admin' then true else false end as Isadmin
	from usuarios_areas ua 
	inner join usuario u on ua.id_usuario =u.id_user 
	inner join area_departamental ad on ua.id_area =ad.id_area 
	inner join roles r on ua.id_rol =r.id_rol
	where ua.estado = true and cast(u.id_user as varchar(500)) = p_id_user; 
end;
$BODY$


DROP FUNCTION data_user_area(character varying);

create or replace function data_user_area(p_id_user varchar(500))
returns table
(
	r_id_area int, r_isadmin_area bool
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select 
	ad.id_area ,  ua.rol_area 
	from usuarios_areas ua 
	inner join usuario u on ua.id_usuario =u.id_user 
	inner join area_departamental ad on ua.id_area =ad.id_area 
	where ua.estado = true and cast(u.id_user as varchar(500)) = p_id_user
	and rol_area = true; 
end;
$BODY$

select * from usuarios_areas ua ;

--probar la funcion
select * from data_user_area ('6a8245c9-153f-4163-b6bc-e3279b36d789');

select * from usuario u where id_user ='6a8245c9-153f-4163-b6bc-e3279b36d789'

select * from usuario u where id_user= 'c09cda3f-0346-4243-8e59-82d8741e32b1';

select * from area_departamental ad ;

select * from area_allData();

--Funcion para retornar los datos de un area segun su id
create or replace function area_allData_id(p_id_area int)
returns table
(
	Area_id int, NombreArea varchar(200), EstadoArea bool, LogoArea varchar(500)
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select ad.id_area, ad.nombre_area, ad.estado,ad.logo_url from area_departamental ad
	where ad.id_area=p_id_area and ad.estado = true;
end;
$BODY$

select * from area_allData_id(6);

---hacer unico el campo del nombre de la tabla area departamental
select * from area_departamental ad ;



alter table area_departamental
  add constraint UQ_NameArea
  unique (nombre_area);
 
 --funcion para ver las URL de los perfiles de las areas xd 
 
 create or replace function area_logo(p_id_area int)
returns table
(
	LogoArea varchar(800)
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select ad.logo_url from area_departamental ad
	where ad.id_area=p_id_area and ad.estado = true;
end;
$BODY$

select * from area_departamental ad ;
select * from area_logo(11);

select * from area_departamental ad ;
 

update area_departamental  set logo_url = '../../uploads/areas/perfiles/perfilbarcelonistactivo-1688346800712.png' where id_area = '1';
update area_departamental  set logo_url = '../../uploads/areas/perfiles/perfilbarcelonistactivo-1688346800712.png' where id_area = '2';
update area_departamental  set logo_url = '../../uploads/areas/perfiles/perfilbarcelonistactivo-1688346800712.png' where id_area = '3';
update area_departamental  set logo_url = '../../uploads/areas/perfiles/perfilbarcelonistactivo-1688346800712.png' where id_area = '4';
update area_departamental  set logo_url = '../../uploads/areas/perfiles/perfilbarcelonistactivo-1688346800712.png' where id_area = '5';
update area_departamental  set logo_url = '../../uploads/areas/perfiles/perfilbarcelonistactivo-1688346800712.png' where id_area = '6';
update area_departamental  set logo_url = '../../uploads/areas/perfiles/perfilbarcelonistactivo-1688346800712.png' where id_area = '7';
update area_departamental  set logo_url = '../../uploads/areas/perfiles/perfilbarcelonistactivo-1688346800712.png' where id_area = '8';
update area_departamental  set logo_url = '../../uploads/areas/perfiles/perfilbarcelonistactivo-1688346800712.png' where id_area = '9';
update area_departamental  set logo_url = '../../uploads/areas/perfiles/perfilbarcelonistactivo-1688346800712.png' where id_area = '10';


--crear tabla para los niveles de las areas 
create table niveles_areas(
	Id_nivel int generated always as identity,
	fecha_creacion  TIMESTAMPTZ DEFAULT Now(),
	ID_Area_Padre int not NULL,
	ID_Area_Hijo int not NULL,
	Estado bool not NULL,
	primary Key(Id_nivel)
);

drop table niveles_areas ;

--Relacionar la Tabla Area con niveles areas
alter table niveles_areas add constraint ID_Area_Padre foreign key (ID_Area_Padre) references area_departamental(id_area);
alter table niveles_areas add constraint ID_Area_Hijo foreign key (ID_Area_Hijo) references area_departamental(id_area);


alter table area_departamental alter column cabezera set default true;
 alter table area_departamental alter column cabezera set not null;

ALTER TABLE area_departamental 
ADD COLUMN cabezera bool;

select * from area_departamental ad ;

ALTER TABLE area_departamental  
DROP COLUMN id_nivel;

update area_departamental  set logo_url = '../../uploads/areas/perfiles/depositphotos_77705002-stock-illustration-original-square-with-round-corners-1688795091728.jpg' where id_area = 28;
update area_departamental  set cabezera = true where id_area = 1;
update area_departamental  set cabezera = true where id_area = 2;
update area_departamental  set cabezera = true where id_area = 3;
update area_departamental  set cabezera = true where id_area = 4;
update area_departamental  set cabezera = true where id_area = 5;
update area_departamental  set cabezera = true where id_area = 6;
update area_departamental  set cabezera = true where id_area = 7;
update area_departamental  set cabezera = true where id_area = 8;
update area_departamental  set cabezera = true where id_area = 10;
update area_departamental  set cabezera = true where id_area = 12;
update area_departamental  set cabezera = true where id_area = 13;


alter table niveles_areas alter column estado set default true;
 alter table area_departamental alter column nombre_area set Unique;

ALTER TABLE area_departamental ADD CONSTRAINT UQ_NombreArea UNIQUE (nombre_area);



select * from area_departamental;
select * from niveles_areas na ;
--proceso almacenado para crear las areas 
Create or Replace Procedure crear_area_hijo(p_nombres varchar(200),
										p_logo_area varchar(500),
										p_id_padre int)
Language 'plpgsql'
AS $$
declare
	ID_A int =0;
Begin
	insert into area_departamental(nombre_area,logo_url,cabezera)values
	(p_nombres,p_logo_area,false);
	select into ID_A id_area from area_departamental where nombre_area=p_nombres;
	insert into niveles_areas(id_area_padre,id_area_hijo)values(p_id_padre,ID_A);
COMMIT;
END;
$$;




call crear_area_hijo('HijoPrueba','asd',11);

delete from area_departamental where cabezera=false;
delete from niveles_areas where id_nivel = 2;
delete from niveles_areas where id_nivel = 3;
delete from niveles_areas where id_nivel = 4;
delete from niveles_areas where id_nivel = 5;
delete from niveles_areas where id_nivel = 6;
delete from niveles_areas where id_nivel = 7;
delete from niveles_areas where id_nivel = 8;
delete from niveles_areas where id_nivel = 9;

select * from niveles_areas na ;
select * from area_departamental;

ALTER TABLE niveles_areas 
ADD COLUMN cabezera int;

 alter table niveles_areas alter column cabezera set not null;


--Aqui hacer el trigger antes de insertar un nivel en la tabla niveles para verificar la cabecera del nivel

create or replace function insert_cabecera() returns trigger 
as 
$$
---Declarar variables
declare
	Padre_Arbol int;
	Padre int;
	Padre_Cabecera int;
	Seguir bool=true;
	Is_hijo bool;
begin 
		---Verifiicar si el area que se esta ingresando es hijo si no es hijo es decir no es cabecera no hacer nada xd
		select into Is_hijo cabezera  from area_departamental where id_area=new.id_area_hijo;
		if(Is_hijo) then
			--no es hijo
			raise exception 'El area que se intenta ingresar no es hijo (%)(%)',new.id_area_hijo,Is_hijo;
			else 
			--Es hijo
			--Almacenar el id del padre anterior
			select into Padre_Arbol id_area_padre from niveles_areas where id_area_hijo=new.id_area_padre;
			--preguntar si no es nullo el padre arbol
				if(Padre_Arbol is not null) then
					select into Padre Padre_Arbol;
					--Si no es nullo entonces hay mas niveles 
						while Seguir loop
   							--aqui seguir buscndo mas niveles
							select into Padre_Arbol id_area_padre from niveles_areas where id_area_hijo=Padre;
								if (Padre_Arbol is not null)then
									select into Padre Padre_Arbol;
								else 
									select into Seguir false;
								end if;
						end loop;
						new.cabezera=Padre;
				else 
				--como es nullo entonces se inserta el valor padre 
				new.cabezera=new.id_area_padre;
				end if;
		end if;
return new;
end
$$
language 'plpgsql';
--Crear la funcion para ejecutar el trigger 
create trigger InsCabecera
before insert 
on niveles_areas
for each row 
execute procedure insert_cabecera();

--para elinar un trigger 
DROP TRIGGER InsCabecera
ON niveles_areas;
--eliminar funcion
DROP FUNCTION insert_cabecera();


--verificar el trigger de inserccion en la tabla niveles
call crear_area_hijo('PruebaHijop1', 'logourl',1) 

insert into niveles_areas(id_area_padre,id_area_hijo)values(1,5);
update area_departamental  set cabezera = false where id_area = 11;

delete from area_departamental where cabezera=false;
delete from niveles_areas where estado=true;



select * from niveles_areas na ;
select * from area_departamental ad ;
select cabezera  from area_departamental where id_area=11;

--drop function jerarquias_areas;
--Funcion para ver las jerarquias de un area desde la cabecera 
create or replace function jerarquias_areas(p_id_area int)
returns table
(
	Area_id int,Padre_id int, NombreArea varchar(200),  LogoArea varchar(500), Cabezer bool
)
language 'plpgsql'
as
$BODY$
declare
	ID_Cabecera int;
	ID_Cabecera1 int;
begin
	--return query
	--primero obtener el ID cabecera si es un area_hijo o padre
	select into ID_Cabecera na.cabezera from niveles_areas na where na.id_area_hijo=p_id_area;
	select into ID_Cabecera1 na.cabezera from niveles_areas na where na.id_area_padre=p_id_area;
	--si no es null entonces es hijo
	if(ID_Cabecera is not null) then
	return query
			select * from
			((select id_area,id_area,nombre_area,logo_url,cabezera from area_departamental where id_area=ID_Cabecera)
			union all
			(select ad.id_area,na.id_area_padre,ad.nombre_area,ad.logo_url,ad.cabezera from niveles_areas na
			inner join area_departamental ad on na.id_area_hijo =ad.id_area 
			where na.cabezera=ID_Cabecera
			order by na.id_nivel asc))as x;
	--si no es null entonces es padre
	elseif (ID_Cabecera1 is not null) then
	return query
	select * from
			((select id_area,id_area,nombre_area,logo_url,cabezera from area_departamental where id_area=ID_Cabecera1)
			union all
			(select ad.id_area,na.id_area_padre,ad.nombre_area,ad.logo_url,ad.cabezera from niveles_areas na
			inner join area_departamental ad on na.id_area_hijo =ad.id_area 
			where na.cabezera=ID_Cabecera1
			order by na.id_nivel asc))as x;
	--si todos son nullos entonces es cabezera
	else 
	return query
			select id_area,id_area,nombre_area,logo_url,cabezera from area_departamental where id_area=p_id_area;
	end if;
end;
$BODY$



select * from
			((select id_area,cabezera,nombre_area,logo_url,cabezera from area_departamental where id_area=1)
			union all
			(select ad.id_area,na.id_area_padre,ad.nombre_area,ad.logo_url,ad.cabezera from niveles_areas na
			inner join area_departamental ad on na.id_area_hijo =ad.id_area 
			where na.cabezera=1
			order by na.id_nivel asc))as x;



	select cabezera from niveles_areas na where na.id_area_hijo=41;
	
select * from niveles_areas na ;
select * from area_departamental ad ;

select * from jerarquias_areas(1);


			select * from
			(select id_area,nombre_area,logo_url,cabezera from area_departamental where id_area=1)
			as x inner join
			(select ad.id_area,ad.nombre_area,ad.logo_url,ad.cabezera from niveles_areas na
			inner join area_departamental ad on na.id_area_hijo =ad.id_area 
			where na.cabezera=1
			order by na.id_nivel asc)
			as Y
			on 10=10
			
			select * from
			((select id_area,nombre_area,logo_url,cabezera from area_departamental where id_area=1)
			union all
			(select ad.id_area,ad.nombre_area,ad.logo_url,ad.cabezera from niveles_areas na
			inner join area_departamental ad on na.id_area_hijo =ad.id_area 
			where na.cabezera=1
			order by na.id_nivel asc))as x
			
--verificar que tambien se una la otra tabla xd 
select id_area,nombre_area,logo_url,cabezera from area_departamental where id_area=1;

			
			
select * from area_departamental ad ;

alter table area_departamental alter column logo_url set default '../../uploads/areas/perfiles/traffic_2_icon-icons.com_76963.png';



--crear un trigger cuando se inserta un area para corregir el problema de que la imagen sale undefined 
create or replace function insert_img_default_area() returns trigger 
as 
$$
begin 
		if trim(new.nombre_area)='' then
			raise exception 'Nombre de area no puede ser vacio';
		end if;
		if length(new.prefijo_departamento)<>5 then
					raise exception 'El prefijo requiere 5 digitos';
		end if;
		if(new.logo_url='../../uploads/areas/perfiles/undefined') then
			new.logo_url='../../uploads/areas/perfiles/traffic_2_icon-icons.com_76963.png';
		end if;
return new;
end
$$
language 'plpgsql';
--Crear la funcion para ejecutar el trigger 
create trigger InsImgArea
before insert 
on area_departamental
for each row 
execute procedure insert_img_default_area();

--para elinar un trigger 
DROP TRIGGER InsImgArea
ON area_departamental;
--eliminar funcion
DROP FUNCTION insert_img_default_area();


select * from niveles_areas na ;
select * from usuario u ;


---modificar la funcion usuariso sin area pero no eliminar el codigo ya que puede servir para otra consulta
create or replace function user_sin_area1(p_ida_area int)
returns table
(
	U_foto varchar(500), U_nombres varchar(500), U_Correo varchar(500), U_Correo2 varchar(500),
	U_Id_User varchar(500), U_Identificacion  varchar(500)
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select u2.url_foto ,u2.nombres ,u2.correo_personal ,u2.correo_institucional ,cast(u2.id_user as varchar(500)) ,u2.identificacion  from
(select u.id_user as id  from usuario u  where u.estado = true
except
select u.id_user as id from usuario u 
inner join usuarios_areas ua on u.id_user =ua.id_usuario 
inner join area_departamental ad on ad.id_area =ua.id_area 
where ua.id_area=p_ida_area and u.estado =true and ua.estado = true)as x
inner join usuario u2 on x.id=u2.id_user ;
end;
$BODY$

select * from user_sin_area();


select u.url_foto,u.nombres ,u.correo_personal from usuario u ;
	select u.url_foto,u.nombres ,u.correo_personal ,u.correo_institucional ,cast(u.id_user as varchar(500)) ,u.identificacion 
from usuario u  left join usuarios_areas ua on u.id_user =ua.id_usuario where ua.id_usuario isnull and u.estado =true  ;



select * from usuario u ;

select * from area_departamental ad ;
select * from usuarios_areas ua ;



--usuarios relacionados con areas
select * from usuario u 
inner join usuarios_areas ua on u.id_user =ua.id_usuario 
inner join area_departamental ad on ua.id_area =2 ;
--usuarios que no estan dentro de un area especifica


--usuarios que si tienen area

--usuarios que no estan dentro de un area

select u2.url_foto ,u2.nombres ,u2.correo_personal ,u2.correo_institucional ,cast(u2.id_user as varchar(500)) ,u2.identificacion  from
(select u.id_user as id  from usuario u  where u.estado = true
except
select u.id_user as id from usuario u 
inner join usuarios_areas ua on u.id_user =ua.id_usuario 
inner join area_departamental ad on ad.id_area =ua.id_area 
where ua.id_area=2 and u.estado =true and ua.estado = true)as x
inner join usuario u2 on x.id=u2.id_user 



select u.url_foto,u.nombres ,u.correo_personal ,u.correo_institucional ,cast(u.id_user as varchar(500)) ,u.identificacion 
from usuario u   where u.estado =true  ;



select * from usuario u ;
select * from area_departamental ad where ad.id_area =2;

select * from usuarios_areas ua 
inner join  usuario u on ua.id_usuario =u.id_user 
inner join area_departamental ad on ad.id_area  =ua.id_area  where ua.id_area =2 ;


 

select * from usuario u where u.id_user ='0ffe7d2c-779b-41ac-9186-4ca196edb230'



--Funcion para ver los datos del perfil segun el id 
select u.nombres ,u.tipo_identificacion ,u.identificacion ,u.correo_personal ,u.correo_institucional ,
u.numero_celular , u.nombre_firma 
from usuario u where u.id_user ='0ffe7d2c-779b-41ac-9186-4ca196edb230';


create or replace function data_user_p(p_user_id varchar(500))
returns table
(
	U_Nombres varchar(500), U_Tipo_Identificacion varchar(500), U_Identificacion varchar(500),
	U_CorreoPersonal varchar(500), U_Correo_Institucional varchar(500), U_Numero_celular varchar(500),
	U_Nombre_Firma varchar(500)
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select u.nombres ,u.tipo_identificacion ,u.identificacion ,u.correo_personal ,u.correo_institucional ,
	u.numero_celular , u.nombre_firma 
	from usuario u where  cast(u.id_user as varchar(500)) =p_user_id;
end;
$BODY$

 cast(u.id_user as varchar(500)) = '2865e766-3a30-48c1-a353-089dda4734fb' 
 
 
	 select * from data_user_p('2865e766-3a30-48c1-a353-089dda4734fb' );
	
	
	select * from usuario u ;



--PROCEDURE para editar el perfil de un usuario OJITO SOLO DATOS SIN FOTOS NI CONTRASENA


Create or Replace Procedure Editar_Usuario(p_nombres varchar(200),
										  p_tipo_identificacion varchar(50),
										  p_identificacion varchar(15),
										  p_correo1 varchar(100),
										  p_correo2 varchar(100),
							  			  p_celular varchar(15),
										  p_firma varchar(100),
										  p_id_user varchar(500)
										 )
Language 'plpgsql'
AS $$
Begin
--update area_departamental  set cabezera = false where id_area = 11;
update usuario set nombres=p_nombres, tipo_identificacion= p_tipo_identificacion, identificacion=p_identificacion,
correo_personal=p_correo1, correo_institucional=p_correo2,numero_celular=p_celular, nombre_firma=p_firma 
where  cast(id_user as varchar(500)) = p_id_user;
COMMIT;
END;
$$;

--modificar los datos de un usuario sin admin, no puede editar, nombres, tipo identificacion, identificacion y
--correo institucional 
Create or Replace Procedure Editar_Usuario_not_admin(	 
										  p_correo1 varchar(100),
							  			  p_celular varchar(15),
										  p_firma varchar(100),
										  p_id_user varchar(500)
										 )
Language 'plpgsql'
AS $$
Begin
--update area_departamental  set cabezera = false where id_area = 11;
update usuario set 
correo_personal=p_correo1, numero_celular=p_celular, nombre_firma=p_firma 
where  cast(id_user as varchar(500)) = p_id_user;
COMMIT;
END;
$$;


select * from usuario u where id_user ='0ffe7d2c-779b-41ac-9186-4ca196edb230' ;
call Editar_Usuario('Raul Steven Coello Castillo Admin',
'Cedula',
'12345678912',
'castillosteven092@outlook.es',
'rcoelloc22@uteq.edu.ec',
'0997669756',
'Raul',
'c09cda3f-0346-4243-8e59-82d8741e32b1');

select * from usuario u;





--Listar los usuarios por las areas a las que corresponde si es admin 


select ad.id_area ,ad.nombre_area,r.rol  from usuario u 
inner join usuarios_areas ua on u.id_user =ua.id_usuario 
inner join area_departamental ad on ua.id_area =ad.id_area 
inner join roles r on ua.id_rol =r.id_rol 
where u.id_user ='c09cda3f-0346-4243-8e59-82d8741e32b1' and ua.estado =true


select * from area_departamental ad2;
--funcion para listar las areas con su rol de cada usuario
drop function usuarios_areas_rol(p_user_id varchar(500));
create or replace function usuarios_areas_rol(p_user_id varchar(500))
returns table
(
	A_id_area int4, A_nombre_area varchar(500), A_rol varchar(500), A_Prefijo varchar(5)
)
language 'plpgsql'
as
$BODY$
begin
		return query
	select ad.id_area ,ad.nombre_area,r.rol,ad.prefijo_departamento  from usuario u 
	inner join usuarios_areas ua on u.id_user =ua.id_usuario 
	inner join area_departamental ad on ua.id_area =ad.id_area 
	inner join roles r on ua.id_rol =r.id_rol 
	where  cast(u.id_user as varchar(500)) =p_user_id and ua.estado =true;
end;
$BODY$

select * from usuarios_areas_rol('c09cda3f-0346-4243-8e59-82d8741e32b1');
select * from area_allData_id(1)

select * from usuario u ;


select * from jerarquias_areas(1);

select * from niveles_areas na 


--Crear una tabla categoria de proyecto 
--tendra un identity int 
--nombre categoria
--prefijo o codigo categoria 
-- descripcion de categoria
--estado]
drop table categorias_proyecto ;
--eleminar el constraint
 ALTER TABLE categorias_proyecto DROP CONSTRAINT id_categoria ;
 ALTER TABLE proyectos DROP CONSTRAINT id_categoria ;


create table categorias_proyecto(
	ID_Categoria int generated always as identity,
	nombre_categoria varchar(200) not null unique,
	prefijo_categoria varchar(5) not null unique,
	descripcion varchar(200) not null,
	estado bool default true,
	fecha_creacion TIMESTAMPTZ DEFAULT Now(),
	primary Key(ID_Categoria)
);

--crear una tabla para proyectos de area
create table proyectos(
	ID_Proyecto int generated always as identity,
	Titulo varchar(500) not null unique,
	Codigo varchar(100) not null unique,
	Fecha_creacion TIMESTAMPTZ DEFAULT Now(),
	Estado bool default true,
	Id_Area_responsable int,
	Id_Categoria int,
	primary key(ID_Proyecto)

);

--crear una tabla para las url de los archivos que tenga ese proyecto 
--TODOS EN PDF 
--Tiene que tener un estado true o false 
create table documentos_proyectos(
	ID_documento int generated always as identity,
	URl_Doc varchar(500)not null,
	Estado bool default true not null,
	ID_Proyecto int,
	Fecha_creacion TIMESTAMPTZ DEFAULT Now(),
		primary key(ID_documento)
);
--constraint para conectar un proyecto con una categoria
alter table proyectos add constraint Id_Categoria foreign key (Id_Categoria) references categorias_proyecto(ID_Categoria);
--constraint para conectar un proyecto con un area 
alter table proyectos add constraint Id_Area_responsable foreign key (Id_Area_responsable) references area_departamental(id_area);
-- constraint para conectar un documento con un proyecto
alter table documentos_proyectos add constraint ID_Proyecto foreign key (ID_Proyecto) references proyectos(ID_Proyecto);

--Crear un proceso almacenado para guardar una categoria de proyecto
select * from categorias_proyecto;

Create or Replace Procedure crear_categoria_proyecto(p_nombre varchar(200),
										p_prefijo varchar(200),
										p_descripcion varchar(200))
Language 'plpgsql'
AS $$
Begin
	insert into categorias_proyecto(nombre_categoria,prefijo_categoria,descripcion)values
	(p_nombre,p_prefijo,p_descripcion);
COMMIT;
END;
$$;

call crear_categoria_proyecto('Cat Prueba1', 'CatP1', 'Esta categoria solo es de prueba'); 
select * from categorias_proyecto cp ;

--anadir un nuevo campo a la tabla proyecto que sea PREFIJO PROYECTO que sea unico y not null
alter table proyectos 
add column prefijo_proyecto varchar(5);

select * from proyectos p ;
--anadir el unique
alter table proyectos
  add constraint UQ_Prefijo_Proyectos
  unique (prefijo_proyecto);
 --anadir not null al campo
 alter table proyectos alter column prefijo_proyecto set not null;


--crear procedimiento almacenado para crear un proyecto
select * from proyectos p ;

Create or Replace Procedure crear_proyecto(p_titulo varchar(200),
										   p_id_area int,
										   p_id_categoria int,
										   p_prefijo_proyecto varchar(5))
Language 'plpgsql'
AS $$
declare 
	p_id_proyecto  int;
	p_nombre_area varchar(500);
begin
	if trim(p_titulo)='' then
			raise exception 'Titulo no puede ser vacio';	
	end if;
	if trim(p_prefijo_proyecto)='' then
			raise exception 'Prefijo no puede ser vacio';
	end if;
	
	insert into proyectos(titulo,id_area_responsable,id_categoria,prefijo_proyecto,versionp)values
	(p_titulo,p_id_area,p_id_categoria,p_prefijo_proyecto,1.0);
	--Aqui anadir agregar a historial proyecto
	--primero obtener el id del ultimo proyecto creado 
	select id_proyecto into p_id_proyecto from proyectos p order by p.id_proyecto desc limit 1;
	--obtener el nombre del area 
	select ad.nombre_area into p_nombre_area from area_departamental ad where ad.id_area = p_id_area;
	--ahora insertar el historial del proyecto con tipo=1 que seria creacion 
	insert into historial_proyecto (detalle,boton,tipo,id_proyecto,Descripcion, titulo)
	values (concat('El area: ',p_nombre_area, ' creó el proyecto : ',p_titulo),false,1,p_id_proyecto,'Se crea un proyecto','Creación del proyecto');

	 EXCEPTION
        WHEN OTHERS THEN
            -- Realiza un rollback explícito para deshacer los cambios
            -- hechos en esta función del trigger
            RAISE EXCEPTION 'Error en el trigger: %', SQLERRM;
            ROLLBACK;
END;
$$;

select * from area_departamental ad ;
select * from categorias_proyecto cp;
select * from proyectos p ;

select url_doc , url_modificado, id_documento  from documentos_proyectos dp where id_proyecto =33;
update documentos_proyectos set url_modificado=url_doc 
alter table documentos_proyectos 
add column url_modificado varchar(500);

select * from documentos_proyectos where id_proyecto =33;
select * from proyectos p ;
--procedimiento almacenado para insertar documentos a los proyectos
Create or Replace Procedure documento_proyecto(p_url varchar(200),
										   p_id_proyecto varchar(200),
										   p_descripcion varchar(100)
										   )
Language 'plpgsql'
AS $$
begin
	--agregar tambien el otro tipo de documento URL2 que seria el documento que verian las demas areas
	insert into documentos_proyectos(url_doc,id_proyecto,descripcion,url_modificado)values
	(p_url,cast(p_id_proyecto as int),p_descripcion,p_url);
	--aqui anadir al historial que se subio un documento con su descripcion xd el tipo =2 
	insert into historial_proyecto (detalle,boton,tipo,id_proyecto,Descripcion, titulo)
	values (concat('Se subió el documento: ',p_descripcion),
	false,2,cast(p_id_proyecto as int),'Se sube un documento','Subir documento');
	EXCEPTION
        -- Si ocurre un error en la transacción principal, revertir
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE EXCEPTION 'Ha ocurrido un error en la transacción principal: %', SQLERRM;
END;
$$;

--Nuevas actividades en la base de datos:
--Crear un trigger en Categorias para que controle que el prefijo de la categoria si o si tenga 5 caracteres
--Crear un trigger en Proyectos que combine los prefijos para crear el codigo del proyecto 


--agregar un campo extra a departamentos que se llame prefijo esto es para el codigo del proyecto 
select id_area ,nombre_area ,prefijo_departamento from area_departamental ad  ;
--primero anadir el campo y manualmente llenar todas las areas con un valor para luego ponerle restrcciones unique 
--y not null 

alter table area_departamental 
add column prefijo_departamento varchar(5);

update area_departamental  set prefijo_departamento = 'A2PR2' where id_area=3;
update area_departamental  set prefijo_departamento = 'AREA1' where id_area=1;
update area_departamental  set prefijo_departamento = 'AREP2' where id_area=2;
update area_departamental  set prefijo_departamento = 'ARPR2' where id_area=42;
update area_departamental  set prefijo_departamento = 'ARRE4' where id_area=4;
update area_departamental  set prefijo_departamento = 'ARRE5' where id_area=5;
update area_departamental  set prefijo_departamento = 'ADMIS' where id_area=6;
update area_departamental  set prefijo_departamento = 'TESTO' where id_area=7;
update area_departamental  set prefijo_departamento = 'ARROD' where id_area=8;
update area_departamental  set prefijo_departamento = 'ASOFT' where id_area=10;
update area_departamental  set prefijo_departamento = 'PRIMA' where id_area=12;
update area_departamental  set prefijo_departamento = 'ASDAR' where id_area=13;
update area_departamental  set prefijo_departamento = 'PRU69' where id_area=9;
update area_departamental  set prefijo_departamento = 'PRPAD' where id_area=16;
update area_departamental  set prefijo_departamento = 'PRUHJ' where id_area=17;
update area_departamental  set prefijo_departamento = 'PRUH2' where id_area=18;
update area_departamental  set prefijo_departamento = 'PRB43' where id_area=19;
update area_departamental  set prefijo_departamento = 'PDR22' where id_area=25;
update area_departamental  set prefijo_departamento = 'PDR99' where id_area=27;
update area_departamental  set prefijo_departamento = 'ARRAB' where id_area=29;
update area_departamental  set prefijo_departamento = 'HIJ12' where id_area=43;
update area_departamental  set prefijo_departamento = 'HJIMG' where id_area=49;
update area_departamental  set prefijo_departamento = 'RAMA3' where id_area=50;
update area_departamental  set prefijo_departamento = 'RAMA2' where id_area=51;


update usuario set nombres=p_nombres, tipo_identificacion= p_tipo_identificacion, identificacion=p_identificacion,
correo_personal=p_correo1, correo_institucional=p_correo2,numero_celular=p_celular, nombre_firma=p_firma 
where  cast(id_user as varchar(500)) = p_id_user;

select * from proyectos p ;
--anadir el unique
alter table area_departamental
  add constraint UQ_Prefijo_Departamento
  unique (prefijo_departamento);
 --anadir not null al campo
 alter table area_departamental alter column prefijo_departamento set not null;


CREATE OR REPLACE PROCEDURE public.crear_area_padre(IN p_nombres character varying, IN p_logo_area character varying,p_prefijo character varying)
 LANGUAGE plpgsql
AS $procedure$
Begin

	insert into area_departamental(nombre_area,logo_url,prefijo_departamento)values
	(p_nombres,p_logo_area,p_prefijo);
COMMIT;
END;
$procedure$
;


CREATE OR REPLACE PROCEDURE public.crear_area_hijo(IN p_nombres character varying, IN p_logo_area character varying, IN p_id_padre integer,IN p_prefijo character varying)
 LANGUAGE plpgsql
AS $procedure$
declare
	ID_A int =0;
Begin
	insert into area_departamental(nombre_area,logo_url,cabezera,prefijo_departamento)values
	(p_nombres,p_logo_area,false,p_prefijo);
	select into ID_A id_area from area_departamental where nombre_area=p_nombres;
	insert into niveles_areas(id_area_padre,id_area_hijo)values(p_id_padre,ID_A);
COMMIT;
END;
$procedure$
;

select * from area_departamental ad 


select * from area_allData();
select * from proyectos p ;

--retornar todos los proyecto de un area siempre y cuando su estado sea true 

create or replace function User_Perfil(idu varchar(500))
returns table
(
	Url_foto_User varchar(800)
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select url_foto  from usuario where cast(id_user as varchar(500))=idu;
end;
$BODY$


--funcion que retorne los proyectos segun el area
select * from proyectos p ;
select * from categorias_proyecto cp ;


DROP FUNCTION proyectos_areas(integer) ;

create or replace function proyectos_areas(p_id_area int)
returns table
(
	p_id_proyecto int, p_titulo varchar(800), p_codigo varchar(100), p_estado bool, p_prefijo varchar(5), p_categoria varchar(100),p_subir bool
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select p.id_proyecto,p.titulo, p.codigo, p.estado,p.prefijo_proyecto, cp.nombre_categoria ,p.subir_docs
	from proyectos p inner join categorias_proyecto cp on p.id_categoria=cp.id_categoria
	where p.id_area_responsable = p_id_area;
end;
$BODY$

select * from proyectos_areas(2);


select * from categorias_proyecto cp ;

--funcion para listar las categorias de proyectos 
create or replace function categorias_proyectos()
returns table
(
	c_categoria_id int, c_nombre_categoria varchar(500), c_prefijo varchar(5), c_descripcion varchar(500)
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select cp.id_categoria,cp.nombre_categoria,cp.prefijo_categoria,cp.descripcion
	from categorias_proyecto cp where cp.estado=true;
end;
$BODY$




select * from proyectos p ;

select * from categorias_proyectos();


select * from proyectos_areas(2);

--prefijo proyecto-prefijo del area- prefijo categoria-identity del proyecto

select * from proyectos p ;
--trigger cuando se crea un proyecto 

create or replace function create_proyect_prefij() returns trigger 
as 
$$
---Declarar variables
declare
	Pref_area varchar(5);
	Pref_cat varchar(5);
begin
	if length(new.prefijo_proyecto) = 5 then
	select into Pref_area ad.prefijo_departamento from area_departamental ad where ad.id_area = new.id_area_responsable;
	select into Pref_cat cp.prefijo_categoria from categorias_proyecto cp where cp.id_categoria = new.id_categoria;
	new.codigo = concat(new.prefijo_proyecto,'-', Pref_area,'-',Pref_cat,'-',new.versionp);
	--aqeui
	else 
		raise exception 'El prefijo del proyecto tiene que tener 5 digitos';
	end if; 
	if trim(new.titulo)='' then
			raise exception 'Titulo no puede estar vacio';
	end if;
	if trim(new.prefijo_proyecto)='' then
			raise exception 'Prefijo no puede estar vacio';
	end if;
		
return new;
end
$$
language 'plpgsql';

create trigger InsProyecto
before insert 
on proyectos
for each row 
execute procedure create_proyect_prefij();


DROP TRIGGER InsProyecto
ON proyectos;
--eliminar funcion
DROP FUNCTION create_proyect_prefij();

select * from proyectos p ;
--probar el trigger xdxdxd jijij ja
call crear_proyecto('s',2,1,'ssss7');



select * from proyectos p ;
select * from area_departamental ad ;
select * from categorias_proyecto cp ;


delete from proyectos where id_proyecto=14;



create or replace function insert_img_default_area() returns trigger 
as 
$$

begin 
		if(new.logo_url='../../uploads/areas/perfiles/undefined') then
			new.logo_url='../../uploads/areas/perfiles/traffic_2_icon-icons.com_76963.png';
		end if;
return new;
end
$$
language 'plpgsql';
--Crear la funcion para ejecutar el trigger 
create trigger InsImgArea
before insert 
on area_departamental
for each row 
execute procedure insert_img_default_area();
select * from user_sin_area();


select * from proyectos p ;
--anadir un campo a proyectos para saber si se va a subir documentos pdf o se va a trabajar con el ide de texto
alter table proyectos 
add column subir_docs bool;


update proyectos  set subir_docs = true  where id_proyecto=6;
update proyectos  set subir_docs = true  where id_proyecto=8;
update proyectos  set subir_docs = true  where id_proyecto=9;
update proyectos  set subir_docs = true  where id_proyecto=10;
update proyectos  set subir_docs = true  where id_proyecto=11;
update proyectos  set subir_docs = true  where id_proyecto=18;
update proyectos  set subir_docs = true  where id_proyecto=19;

alter table proyectos alter column subir_docs set not null;

alter table proyectos alter column subir_docs set default true;

select * from proyectos p ;


select * from proyectos_areas(2);


--funcion que retorne el tipo de usuario de un proyecto ademas de los datos del 
--proyecto y el area en que el esta el proyecto todo esto segun la id del usuario

select p.titulo,r.rol  from proyectos p 
inner join area_departamental ad on p.id_area_responsable =ad.id_area 
inner join usuarios_areas ua on ad.id_area =ua.id_area 
inner join roles r on ua.id_rol =r.id_rol
where cast(ua.id_usuario as varchar(500))='c09cda3f-0346-4243-8e59-82d8741e32b1' and p.id_proyecto=10 ;

select * from usuarios_areas ua ;

DROP FUNCTION rol_proyecto(character varying,integer);

--anadir que si el proyecto ya tiene un flujo definido 
create or replace function rol_proyecto(p_idu varchar(500),p_id_proyecto int)
returns table
(
	p_titulo varchar(800), p_rol varchar(100),p_subir bool, p_flujo bool
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select * from
	(select p.titulo,case when ua.rol_area then cast('Admin' as varchar(100)) else cast('Not admin' as varchar(100)) end ,p.subir_docs  from proyectos p 
	inner join area_departamental ad on p.id_area_responsable =ad.id_area 
	inner join usuarios_areas ua on ad.id_area =ua.id_area 
		where cast(ua.id_usuario as varchar(500))=p_idu and p.id_proyecto=p_id_proyecto) as x inner join
	(select case when COUNT(*)>0 then true else false end as TieneFLujo from flujo_proyecto fp 
	where id_proyecto = p_id_proyecto and estado =true ) as y on 1=1;
end;
$BODY$

select * from proyectos p ;

select * from rol_proyecto('c09cda3f-0346-4243-8e59-82d8741e32b1',27);

	select * from
	(select p.titulo,case when ua.rol_area then cast('Admin' as varchar(100)) else cast('Not admin' as varchar(100)) end ,p.subir_docs  from proyectos p 
	inner join area_departamental ad on p.id_area_responsable =ad.id_area 
	inner join usuarios_areas ua on ad.id_area =ua.id_area 
		where cast(ua.id_usuario as varchar(500))='c09cda3f-0346-4243-8e59-82d8741e32b1' and p.id_proyecto=27) as x inner join
	(select case when COUNT(*)>0 then true else false end as TieneFLujo from flujo_proyecto fp 
	where id_proyecto = 27 and estado =true ) as y on 1=1;


select * from documentos_proyectos dp ;
'../../uploads/proyectosundefined'
--crear un proceso almacenado para subir documentos al proyecto

Create or Replace Procedure documento_proyecto(p_url varchar(200),
										   p_id_proyecto int
										   )
Language 'plpgsql'
AS $$
Begin
	insert into documentos_proyectos(url_doc,id_proyecto)values
	(p_url,p_id_proyecto);
COMMIT;
END;
$$;

delete from documentos_proyectos ;


'../../uploads/proyectosundefined'

create or replace function upload_pdf() returns trigger 
as 
$$
---Declarar variables

begin
	if (new.url_doc = '../../uploads/proyectos/undefined') then
		raise exception 'Suba un archivo valido';
	end if; 
return new;
end
$$
language 'plpgsql';


create trigger SubirPDF
before insert 
on documentos_proyectos
for each row 
execute procedure upload_pdf();


select * from documentos_proyectos dp ;

--funcion para retornar los documentos de un proyecto y su link xdxd jijij ja 

select * from ver_docs(24);
select * from documentos_proyectos dp ;
drop function ver_docs(integer);
create or replace function ver_docs(p_id_proyecto int)
returns table
(
	d_url varchar(800), d_fecha varchar(500), d_id int, d_descripcion varchar(500)
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select dp.url_doc,cast(TO_CHAR(dp.fecha_creacion, 'DD-MON-YYYY') as varchar(500)), dp.id_documento , dp.descripcion
	from documentos_proyectos dp where dp.id_proyecto=p_id_proyecto and estado =true 
	order by dp.fecha_creacion asc;

end;
$BODY$

select * from proyectos p 


select * from ver_docs(8);

select * from ver_docs(24);


select * from proyectos p ;



select d_url from ver_docs(8) where d_id=10;

select url_doc  from documentos_proyectos where id_documento =10



create or replace function ver_docs_x_id(p_id_doc int)
returns table
(
	d_url varchar(800)
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select url_doc  from documentos_proyectos where id_documento =p_id_doc;
end;
$BODY$


create or replace function ver_docs_x_id_2(p_id_doc int)
returns table
(
	d_url varchar(800)
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select url_modificado  from documentos_proyectos where id_documento =p_id_doc;
end;
$BODY$





delete from documentos_proyectos 



select * from documentos_proyectos dp 

select * from ver_docs_x_id(10);
select * from proyectos_areas(2)


select * from usuario

--trigger para de insert para la tabla usuario para controlar el tipo de identificacion
--y la cantidad de digitos del celular

create or replace function tr_insert_user() returns trigger 
as 
$$
begin
	if new.identificacion  ~ '[^0-9]' then 
		raise exception 'Identificacion solo puede tener numeros';
	end if;
	if new.numero_celular  ~ '[^0-9]' then 
		raise exception 'Celular solo puede tener numeros';
	end if;
	if length(new.numero_celular) <> 10 then
		raise exception 'Celular debe tener 10 digitos';
	end if; 
	if trim(new.nombres)='' then
			raise exception 'Nombres no puede ser vacio';
	end if;
	if trim(new.correo_personal)='' then
			raise exception 'Correo personal no puede ser vacio';
	end if;
	if trim(new.correo_institucional)='' then
			raise exception 'Correo institucional no puede ser vacio';
	end if;
	if trim(new.url_foto)='' then
			new.url_foto='../../uploads/perfiles/user.png';
	end if;
	if trim(new.nombre_firma)='' then
			raise exception 'Firma no puede ser vacio';
	end if;
	--validar si la imagen es correcta si no otorgar una por default
	if(new.url_foto='../../uploads/perfiles/undefined') then
			new.url_foto='../../uploads/perfiles/user.png';
		end if;
	--validar el tamano de la identificacion dependiendo del tipo
	if(new.tipo_identificacion='Cedula')then
		if length(new.identificacion)<>10 then
					raise exception 'Cedula requiere 10 digitos';
		end if;
	end if;
	if(new.tipo_identificacion='Ruc')then
		if length(new.identificacion)<>13 then
					raise exception 'Ruc requiere 13 digitos';
		end if;
	end if;
	if(new.tipo_identificacion='Pasaporte')then
		if length(new.identificacion)<>12 then
					raise exception 'Pasaporte requiere 12 digitos';
		end if;
	end if;
return new;
end
$$
language 'plpgsql';

create trigger Tr_Insertar_usuario
before insert 
on usuario
for each row 
execute procedure tr_insert_user();


create trigger Tr_Actualizar_usuario
before update 
on usuario
for each row 
execute procedure tr_insert_user();


--vaciar la base de datos para empezar con los datos correctos
--no eliminar supero usuario

delete from documentos_proyectos 


delete from proyectos 
delete from niveles_areas 
delete from area_departamental 
delete from usuarios_areas 

select * from usuario u 
delete  from usuario u2 where id_user <>'c09cda3f-0346-4243-8e59-82d8741e32b1'


--proceso almacenado para cambiar la foto de un usuario

Create or Replace Procedure Cambiar_Foto(p_url varchar(900),
										  p_id_user varchar(500)
										 )
Language 'plpgsql'
AS $$
Begin
--update area_departamental  set cabezera = false where id_area = 11;
update usuario set url_foto =p_url
where  cast(id_user as varchar(500)) = p_id_user;
COMMIT;
END;
$$;




select * from usuario u 

--procedure que retorne para actualizar la contrasena de un usuario
Create or Replace Procedure Cambiar_Contra(p_contra_nueva varchar(900),
											p_contra_actual varchar(900),
										   p_id_user varchar(500)
										 )
Language 'plpgsql'
AS $$
Begin
--update area_departamental  set cabezera = false where id_area = 11;
	--primero verificar que la contrasena no este vacia 
	if trim(p_contra_nueva)='' then
			raise exception 'Contraseña no puede ser vacio';
		end if;
	if trim(p_contra_actual)='' then
			raise exception 'Contraseña no puede ser vacio';
		end if;
update usuario set contra =PGP_SYM_ENCRYPT(p_contra_nueva,'SGDV_KEY')
where  cast(id_user as varchar(500)) = p_id_user and PGP_SYM_DECRYPT(contra ::bytea, 'SGDV_KEY') = p_contra_actual;
COMMIT;
END;
$$;


update usuario set contra =PGP_SYM_ENCRYPT('Raul','SGDV_KEY')
where  cast(id_user as varchar(500)) = 'c09cda3f-0346-4243-8e59-82d8741e32b1';

select correo_institucional,PGP_SYM_DECRYPT(contra ::bytea, 'SGDV_KEY')  from usuario u 

call cambiar_contra ('1234','1','c09cda3f-0346-4243-8e59-82d8741e32b1');

---funcion que retone el nombre del usuario cuando ingresa contrasena e id para actualizar su contrasena
create or replace function verficiar_contrasena_id(p_contra_actual varchar(900),
										   p_id_user varchar(500))
returns table
(
	d_url varchar(800)
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select correo_institucional  from usuario u where PGP_SYM_DECRYPT(u.contra ::bytea, 'SGDV_KEY')= p_contra_actual
and cast(id_user as varchar(500)) = p_id_user;

end;
$BODY$

select * from verficiar_contrasena_id('123456','c09cda3f-0346-4243-8e59-82d8741e32b1');





select * from usuarios_areas ua ;


select count(*)  from usuarios_areas ua where ua.id_rol =1 and ua.id_area =58 and ua.estado=true  ;



delete from usuarios_areas


--crear un trigger que compruebe que no halla un suario administrador activo en el area para ingresar uno nuevo xd 
select * from roles r 


select ua2 .id_relacion, ua2 .rol_area from usuarios_areas ua2 

select ua2.id_relacion, ua2.rol_area from usuarios_areas ua2  where id_relacion = 114


select not rol_area from usuarios_areas ua where id_relacion =118;

select not rol_area from usuarios_areas ua where id_relacion =114;


select * from usuarios_areas ua where id_area =58

--162 134
call Cambiar_Rol_Area('162');


select  count(*)  from usuarios_areas ua where ua.rol_area=true and id_area =58 and ua.estado=true;

--esta funcion debe cambiarse al update y no al insert
create or replace function verificar_admin_activo() returns trigger 
as 
$$
---Declarar variables
declare
	Indi int;
	Id_area_p int;
begin
	select into Id_area_p id_area from usuarios_areas where id_relacion = new.id_relacion;
	select into Indi count(*)  from usuarios_areas ua where ua.rol_area=true and id_area =Id_area_p and ua.estado=true;
	if(Indi>=1 and new.rol_area)	then
		raise exception 'Ya existe un usuario administrador activo';
	end if;
return new;
end
$$
language 'plpgsql';

create trigger Verificar_admin
before update 
on usuarios_areas
for each row 
execute procedure verificar_admin_activo();




select * from proyectos p 


select * from area_departamental ad ;



--proceso almacenado para editar los datos del area 
--nombre_area 
--prefijo_departamento
Create or Replace Procedure Editar_Area(p_nombre_area varchar(200),
										  p_prefijo_area varchar(50),
										  p_id_area int
										 )
Language 'plpgsql'
AS $$
Begin
--update area_departamental  set cabezera = false where id_area = 11;
	update area_departamental set nombre_area =p_nombre_area, prefijo_departamento =p_prefijo_area
	--aqui actualizar tambien el codigo de los proyectos xd nose como carajos voy a hacer esto .______.
	where id_area =p_id_area;
COMMIT;
END;data_user_p
$$;


Create or Replace Procedure cambiar_foto_area(p_url_foto varchar(800),
										  p_id_area int
										 )
Language 'plpgsql'
AS $$
Begin
--update area_departamental  set cabezera = false where id_area = 11;
	update area_departamental set logo_url =p_url_foto
	where id_area =p_id_area;
COMMIT;
END;
$$;




--triger para verificar cuando se edita todo el area
create or replace function edit_area() returns trigger 
as 
$$
begin 
		if trim(new.nombre_area)='' then
			raise exception 'Nombre de area no puede ser vacio';
		end if;
		if length(new.prefijo_departamento)<>5 then
					raise exception 'El prefijo requiere 5 digitos';
		end if;
		if(new.logo_url='../../uploads/areas/perfiles/undefined') then
			new.logo_url='../../uploads/areas/perfiles/traffic_2_icon-icons.com_76963.png';
		end if;
		if trim(new.logo_url)='' then
			new.logo_url=old.logo_url;
		end if;
return new;
end
$$
language 'plpgsql';
--Crear la funcion para ejecutar el trigger 
create trigger Update_area
before update 
on area_departamental
for each row 
execute procedure edit_area();

select * from usuario u ;
delete from usuario where id_user  ='b5f6a7c5-d37a-4301-b3e9-32f0d3b62fa9'

---procesidimiento almacenado para crear un usuario dentro del area con un rol
Create or Replace Procedure Crear_Usuario_area(p_nombres varchar(200),
										  p_tipo_identificacion varchar(50),
										  p_identificacion varchar(15),
										  p_correo1 varchar(100),
										  p_correo2 varchar(100),
							  			  p_celular varchar(15),
										  p_foto varchar(500),
										  p_firma varchar(100),
										  p_id_area varchar(100)
										  )
Language 'plpgsql'
AS $$
declare
	ID_A varchar(900);
Begin

	insert into usuario (nombres,tipo_identificacion,identificacion,correo_personal,correo_institucional,numero_celular,url_foto,isadmin,Nombre_firma,Contra)values
	(p_nombres, p_tipo_identificacion,p_identificacion,p_correo1,p_correo2,p_celular,p_foto,false,p_firma,PGP_SYM_ENCRYPT(p_identificacion,'SGDV_KEY'));
	 select into ID_A cast(id_user as varchar(900))  from usuario u where identificacion =p_identificacion;
	--registrar en el area 
	insert into usuarios_areas (id_usuario, id_area)values
	(cast(ID_A as uuid),cast(p_id_area as int));

COMMIT;
END;
$$;


create or replace function verificar_admin_activo() returns trigger 
as 
$$
---Declarar variables
declare
	Indi int;
begin
	select into Indi count(*)  from usuarios_areas ua where ua.id_rol =1 and ua.id_area =new.id_area and ua.estado=true;
	if(Indi=1)	then
		if(new.id_rol=1) then 
		raise exception 'Ya existe un usuario administrador activo';
		end if;
	end if;
return new;
end
$$
language 'plpgsql';

select cast(id_user as varchar(900))  from usuario u where identificacion ='1724305667';

select * from usuarios_areas ua ;
select * from usuario u ;

select  count(*)  from usuarios_areas ua where ua.id_rol =1 and ua.id_area =58 and ua.estado=true;

--procedicimento almacenado para cambiar la contrasena en modo administrador
Create or Replace Procedure Cambiar_Contra_admin(p_contra_nueva varchar(900),
										   p_id_user varchar(500)
										 )
Language 'plpgsql'
AS $$
Begin
--update area_departamental  set cabezera = false where id_area = 11;
	--verificar que la contrasena no venga vacia skere modo diablo 
		if trim(p_contra_nueva)='' then
			raise exception 'Contraseña no puede ser vacio';
		end if;
update usuario set contra =PGP_SYM_ENCRYPT(p_contra_nueva,'SGDV_KEY')
where  cast(id_user as varchar(500)) = p_id_user;
COMMIT;
END;
$$;


--procedimiento almacenado que cambie el estado de la relacion usario-area a false 
select * from usuarios_areas ua 


Create or Replace Procedure Deshabilitar_Usuario_Area(p_id_area int,
										   p_id_user varchar(500)
										 )
Language 'plpgsql'
AS $$
Begin
update usuarios_areas set estado  =false 
where  cast(id_usuario  as varchar(500)) = p_id_user and id_area =p_id_area;
COMMIT;
END;
$$;

select ua2 .id_relacion, ua2 .rol_area from usuarios_areas ua2 
select not rol_area from usuarios_areas ua where id_relacion =118;

select not rol_area from usuarios_areas ua where id_relacion =118;
call Cambiar_Rol_Area('114');
---cambiar el rol que tiene actualmente el usuario dentro de un area si es admin o no es admin
Create or Replace Procedure Cambiar_Rol_Area(
										   p_id_relacion varchar(500)
										 )
Language 'plpgsql'
AS $$
declare 
	Estado_old bool;
Begin
--update area_departamental  set cabezera = false where id_area = 11;
	select into Estado_old not rol_area from usuarios_areas ua where id_relacion =cast(p_id_relacion as int);
		update usuarios_areas set rol_area  = Estado_old
		where  id_relacion = cast(p_id_relacion as int) ;
COMMIT;
END;
$$;


select * from  usuario u ;

--procedimiento almacenado para deshabilitar un usario de toda la app
Create or Replace Procedure Deshabilitar_Usuario(
										   p_id_user varchar(500)
										 )
Language 'plpgsql'
AS $$
declare 
	Estado_old bool;
Begin
--update area_departamental  set cabezera = false where id_area = 11;
	select into Estado_old not estado from usuario where cast(id_user  as varchar(500)) = p_id_user ;
		update usuario set estado  = Estado_old
		where  cast(id_user  as varchar(500)) = p_id_user ;
COMMIT;
END;
$$;

select * from usuario u ;

select  not estado  from usuario u 

select estado  from usuario u where id_user ='391621d1-c386-4419-9aef-070dc311447d' ; 


update usuario set estado  =false
		where  cast(id_user  as varchar(500)) = '391621d1-c386-4419-9aef-070dc311447d' ;


call Deshabilitar_Usuario('391621d1-c386-4419-9aef-070dc311447d' );



select * from area_departamental ad 

select * from usuarios_areas ua 

--modificar esta funcion para que no aparesca si el estado del usuario es false 
select * from user_area(58)


--procedimiento almacenado para crear categoria
select * from categorias_proyecto cp ;

alter table categorias_proyecto
  add constraint UQ_Nombre_Categoria
  unique (nombre_categoria);
 
 alter table categorias_proyecto
  add constraint UQ_Prefijo
  unique (prefijo_categoria);
 
--triger para verificar cuando se creo o se edita que no vaya vacio y que se respete el lenght del prefijo
 create or replace function insert_cat() returns trigger 
as 
$$
begin 
		if trim(new.nombre_categoria)='' then
			raise exception 'Nombre de categoria no puede ser vacio';
		end if;
		if length(new.prefijo_categoria)<>5 then
					raise exception 'El prefijo requiere 5 digitos';
		end if;
		if trim(new.descripcion)='' then
			raise exception 'Descripcion de categoria no puede ser vacio';
		end if;
return new;
end
$$
language 'plpgsql';
--Crear la funcion para ejecutar el trigger 
create trigger Insert_Cat
before insert 
on categorias_proyecto
for each row 
execute procedure insert_cat();

create trigger Update_Cat
before update 
on categorias_proyecto
for each row 
execute procedure insert_cat();




Create or Replace Procedure Crear_Categoria(p_nombres varchar(200),
										 p_prefijo varchar(5),
										 p_descripcion varchar(200))
Language 'plpgsql'
AS $$
Begin
	insert into categorias_proyecto (nombre_categoria,prefijo_categoria,descripcion)
	values
	(p_nombres,p_prefijo,p_descripcion);
COMMIT;
END;
$$;

--editar categoria 
--update area_departamental  set logo_url= '/img/Home/logo-fci-1.jpg' where id_area = 1
--categorias_proyecto
Create or Replace Procedure Editar_Categoria(p_nombres varchar(200),
										 p_prefijo varchar(5),
										 p_descripcion varchar(200),
										 p_id_categoria int)
Language 'plpgsql'
AS $$
Begin
	update categorias_proyecto set nombre_categoria =p_nombres,prefijo_categoria =p_prefijo,descripcion =p_descripcion
	where id_categoria =p_id_categoria;
COMMIT;
END;
$$;

--cambiar estado de la categoria
select not estado  from categorias_proyecto cp ;
select * from categorias_proyecto cp ;


call Estado_Categoria(1);

Create or Replace Procedure Estado_Categoria(
										   p_id_cate varchar(100)
										 )
Language 'plpgsql'
AS $$
declare 
	Estado_old bool;
Begin
--update area_departamental  set cabezera = false where id_area = 11;
	select into Estado_old not estado from categorias_proyecto where  id_categoria=cast(p_id_cate as int) ;
		update categorias_proyecto set estado  = Estado_old
		where  id_categoria = cast(p_id_cate as int);
COMMIT;
END;
$$;
DROP FUNCTION lis_categorias();
--Procedimiento almacenado para enlistar todas las areas sin importa el estado
create or replace function Lis_categorias()
returns table
(
	t_id_categoria int, t_nombre_categoria varchar(500), t_prefijo_categoria varchar(500), t_descripcion varchar(800), t_estado bool,
	t_est varchar(50)
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select id_categoria ,nombre_categoria ,prefijo_categoria ,descripcion ,estado,
	cast(case when estado then 'Habilitado' else 'Deshabilitado' end  as varchar(50))
	from categorias_proyecto;
end;
$BODY$

select * from categorias_proyectos()

select * from Lis_categorias();



select * from


select * from usuarios_areas_rol('c09cda3f-0346-4243-8e59-82d8741e32b1',false);
select * from usuarios_areas_rol('c09cda3f-0346-4243-8e59-82d8741e32b1',true);
select * from usuarios_areas ua ;


drop function usuarios_areas_rol(p_user_id varchar(500),p_areas_admin bool);


create or replace function usuarios_areas_rol(p_user_id varchar(500), p_areas_admin bool)
returns table
(
	A_id_area int4, A_nombre_area varchar(500), A_rol varchar(500), A_Prefijo varchar(5)
)
language 'plpgsql'
as
$BODY$
begin
	if (p_areas_admin) then
	 RETURN QUERY 
	select ad.id_area ,ad.nombre_area,cast('Administrador Area' as varchar(500)),ad.prefijo_departamento  from usuario u 
	inner join usuarios_areas ua on u.id_user =ua.id_usuario 
	inner join area_departamental ad on ua.id_area =ad.id_area 
	where  cast(u.id_user as varchar(500)) =p_user_id and ua.estado =true and ua.rol_area =true;
	else 
	 RETURN QUERY 
	select ad.id_area ,ad.nombre_area,case when  ua.rol_area then cast('Administrador Area' as varchar(500)) else cast('Not Admin' as varchar(500)) end,ad.prefijo_departamento  from usuario u 
	inner join usuarios_areas ua on u.id_user =ua.id_usuario 
	inner join area_departamental ad on ua.id_area =ad.id_area 
	where  cast(u.id_user as varchar(500)) =p_user_id and ua.estado =true;
	end if;
end;
$BODY$


select * from usuario u ;


select * from Users_allData();

select * from Lis_categorias();

select * from proyectos p ;

--crear una tabla para subir documentos de apoyo para un proyecto asi como las guias practicas en el SGA

drop table guias_proyectos;

create table guias_proyectos(
	Id_guia int generated always as identity,
	fecha_creacion  TIMESTAMPTZ DEFAULT Now(),
	Descripcion varchar(500) not null default 'Descripcion Guia',
	Tipo_archivo varchar(500) not null,
	ID_proyecto int not NULL,
	Estado bool not null default true,
	Url_guia varchar(900) not null,
	primary Key(Id_guia)
);
--conectar la tabla guias proyecto con un proyecto 
alter table guias_proyectos add constraint id_proyecto 
	foreign key (ID_proyecto) references proyectos(id_proyecto);


---retornar la lista de las guias de apoyo que existen en un proyecto 
select * from guias_proyectos gp ;
select * from proyectos p ;


cast(TO_CHAR(dp.fecha_creacion, 'DD-MON-YYYY') as varchar(500))

create or replace function List_Guias_proyectos(idp int)
returns table
(
	r_id_guia int, r_descripcion varchar(500), r_fecha varchar(500), r_url_guia varchar(500), r_tipo varchar(500) 
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select id_guia ,descripcion ,cast(TO_CHAR(fecha_creacion, 'DD-MON-YYYY') as varchar(500)), url_guia,tipo_archivo from guias_proyectos gp where id_proyecto =idp;
end;
$BODY$

	select id_guia , descripcion ,fecha_creacion, url_guia,tipo_archivo 
    from guias_proyectos gp where id_proyecto =1;
   
   
 select * from List_Guias_proyectos(1);

--procedure para subir una guia a un proyecto 
select * from guias_proyectos gp ;

select * from guias_proyectos gp ;

update 

-----EMPRESA
--------------TABLA EMPRESA---------------------------

create table empresa(
	id_empresa serial primary key,
	nombre character varying(200) not null,
	direccion character varying(200) not null,
	numero_celular character varying(15) not null,
	correo character varying(100) not null,
	url_logo character varying(500) not null
)
---Trigger para validar el update de la tabla empresa 
CREATE OR REPLACE FUNCTION update_empresa()
	RETURNS TRIGGER AS $$
BEGIN
		-- Validar que el campo no esté vacío
		IF NEW.nombre IS NULL OR trim(NEW.nombre) = '' THEN
		RAISE EXCEPTION 'El nombre no puede estar vacio';
		END IF;
		
		IF NEW.direccion IS NULL OR trim(NEW.direccion) = '' THEN
		RAISE EXCEPTION 'La direccion no puede estar vacia';
		END IF;
	
		IF NEW.numero_celular IS NULL OR trim(NEW.numero_celular) = '' THEN
		RAISE EXCEPTION 'El número de celular no puede estar vacío';
		END IF;
		
		-- Validar que el campo solo contenga números
		If new.numero_celular ~ '[^0-9]' THEN
		RAISE EXCEPTION 'El número de celular solo puede contener números';
		END IF;
		
		-- Validar la cantidad de numeros 10 exactamente
		If length(new.numero_celular) <> 10 THEN
		RAISE EXCEPTION 'El número de celular debe tener 10 digitos';
		END IF;
		
		IF NEW.correo IS NULL OR trim(NEW.correo) = '' THEN
		RAISE EXCEPTION 'El correo no puede ser vacio';
		END IF;
	
		IF NEW.url_logo IS NULL OR trim(NEW.url_logo) = '' THEN
		RAISE EXCEPTION 'La url de la imagen no puede estar vacia';
		END IF;
	
		if(new.url_logo='../../uploads/perfiles/undefined') then
			RAISE EXCEPTION 'Formato de imagen no valido';
		end if;
	
RETURN NEW;
END;
$$ LANGUAGE plpgsql;


--DROP TRIGGER IF EXISTS tr_validar_datos_empresa ON empresa;

CREATE TRIGGER tr_validar_datos_empresa
BEFORE UPDATE ON empresa
FOR EACH ROW
EXECUTE FUNCTION update_empresa();

select * from 
if (select count(*)  from empresa>=1) then
	raise notice 'Ya exsite empresa';
	else 
	raise notice 'No existe registro de empresa';
end if ;


--trigeer antes de insertar empresa 
CREATE OR REPLACE FUNCTION create_empresa()
	RETURNS TRIGGER AS $$
	---Declarar variables
declare
	Datos_exist bool;
begin
		select into Datos_exist case when count(*)>=1 then true else false end from empresa;
		if Datos_exist then 
			RAISE EXCEPTION 'Ya existen datos de empresa';
		end if;
		-- Validar que el campo no esté vacío
		IF NEW.nombre IS NULL OR trim(NEW.nombre) = '' THEN
		RAISE EXCEPTION 'El nombre no puede estar vacio';
		END IF;
		
		IF NEW.direccion IS NULL OR trim(NEW.direccion) = '' THEN
		RAISE EXCEPTION 'La direccion no puede estar vacia';
		END IF;
	
		IF NEW.numero_celular IS NULL OR trim(NEW.numero_celular) = '' THEN
		RAISE EXCEPTION 'El número de celular no puede estar vacío';
		END IF;
		
		-- Validar que el campo solo contenga números
		If new.numero_celular ~ '[^0-9]' THEN
		RAISE EXCEPTION 'El número de celular solo puede contener números';
		END IF;
		
		-- Validar la cantidad de numeros 10 exactamente
		If length(new.numero_celular) <> 10 THEN
		RAISE EXCEPTION 'El número de celular debe tener 10 digitos';
		END IF;
		
		IF NEW.correo IS NULL OR trim(NEW.correo) = '' THEN
		RAISE EXCEPTION 'El correo no puede ser vacio';
		END IF;
	
		IF NEW.url_logo IS NULL OR trim(NEW.url_logo) = '' THEN
		RAISE EXCEPTION 'La url de la imagen no puede estar vacia';
		END IF;
	
		if(new.url_logo='../../uploads/perfiles/undefined') then
			RAISE EXCEPTION 'Formato de imagen no valido';
		end if;
	
RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER existencia_empresa
BEFORE INSERT ON empresa
FOR EACH ROW
EXECUTE FUNCTION create_empresa();


update empresa set url_logo = '../../uploads/perfiles/logo_empresa.png' where id_empresa =4;

select * from empresa;

delete from empresa ;

insert into empresa (nombre,direccion,numero_celular,correo,url_logo) 
values ('UTEQ','ViaQuevedo','0987653534','Uteq@uteq.edu.ec','imagenlogo');


------Bloquear la funcion eliminar datos de empresa 
CREATE OR REPLACE FUNCTION delete_empresa()
	RETURNS TRIGGER AS $$
	---Declarar variables
begin
			RAISE EXCEPTION 'No se puede eliminar los datos de esta tabla';	
RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER eliminar_empresa
BEFORE DELETE ON empresa
FOR EACH ROW
EXECUTE FUNCTION delete_empresa();

------PROCEDIMIENTO PARA EDITAR LOS DATOS DE LA EMPRESA 
CREATE OR REPLACE PROCEDURE public.editar_empresa(
	IN p_nombre character varying,
	IN p_direccion character varying,
	IN p_celular character varying, 
	IN p_correo character varying, 
	IN id_empresa_p int)
    LANGUAGE 'plpgsql'
    
AS $BODY$
Begin
update empresa set nombre=p_nombre, direccion= p_direccion, numero_celular=p_celular,
correo=p_correo where id_empresa =id_empresa_p ;
COMMIT;
END;
$BODY$;


select * from empresa;

call Editar_Empresa('UTEQEditado','ViaQuevedoEditado','0987653666','Uteq@uteq.edu.ec1',4);

---Ver datos empresa 
CREATE OR REPLACE FUNCTION empresa_Data()
    RETURNS TABLE
	(
		empresaid  character varying(100), nombres_empresa character varying(100), direccion_empresa character varying(100), 
		celular_empresa character varying(15), correo_empresa character varying(100), url_logo_empresa character varying(500)
	)
language 'plpgsql'
as
$BODY$
begin
	return query
	select cast(id_empresa as varchar(500)) as empresa_ID,nombre,direccion ,numero_celular ,correo ,url_logo  from empresa;
end;
$BODY$;

---Ver url de la foto de la empresa 
CREATE OR REPLACE FUNCTION empresa_URl()
    RETURNS TABLE
	(
		url_foto  character varying(100))
language 'plpgsql'
as
$BODY$
begin
	return query
	select url_logo from empresa;
end;
$BODY$;

select * from empresa_URl();


--drop FUNCTION public.empresa_Data


select * from empresa e ;

---Cambiar la foto de la empresa
Create or Replace Procedure Cambiar_Foto_Empresa(p_url varchar(900),
										  p_id_empresa varchar(500)
										 )
Language 'plpgsql'
AS $$
Begin
--update area_departamental  set cabezera = false where id_area = 11;
update empresa set url_logo = p_url where id_empresa = cast(p_id_empresa as int);
COMMIT;
END;
$$;





----------------------------------------------------------------FIN EMPRESA


Create or Replace Procedure subir_guia(p_url varchar(200),
										   p_id_proyecto int,
										   p_tipo_archivo varchar(200),
										   p_descripcion_archivo varchar(200)
										   )
Language 'plpgsql'
AS $$
begin
	--verificar que no este vacia la descripcion 
	if trim(p_descripcion_archivo)='' then
			raise exception 'Descripcion no puede ser vacio';
	end if;
	insert into guias_proyectos(descripcion,id_proyecto,url_guia,tipo_archivo)values
	(p_descripcion_archivo,p_id_proyecto,p_url,p_tipo_archivo);
	--aqui anadir al historial del proyecto tipo 2 para saber que es guia
	insert into historial_proyecto (detalle,boton,tipo,id_proyecto,Descripcion, titulo)
	values (concat('Se subio la guia: ',p_descripcion_archivo),false,2,p_id_proyecto,'Se subio una guia','Subir Guia');
COMMIT;
END;
$$;

select * from guias_proyectos gp ;
update guias_proyectos set descripcion ='descripcion' where id_guia = 26;

--trigger para que no se ingresen archivos erroneos
create or replace function insert_guia() returns trigger 
as 
$$
begin 
		if trim(new.url_guia)='' then
			raise exception 'Archivo Incorrecto';
		end if;
		if(new.url_guia='../../uploads/Guias/undefined') then
				raise exception 'Archivo Incorrecto';
		end if;
return new;
end
$$A
language 'plpgsql';
--Crear la funcion para ejecutar el trigger 
create trigger InsGuia
before insert 
on guias_proyectos
for each row 
execute procedure insert_guia();

select * from guias_proyectos gp ;
 select * from List_Guias_proyectos(27);

delete  from guias_proyectos 
update guias_proyectos  set url_guia = '/uploads/Guias/EXPO cliclo de vida-1690510887770.pdf' where id_guia  = 9




-----Ahora no se debe pedir el rol que va a tener un usuario dentro de un area para los proyectos 
--solo se debe pedir si ese usuario va a ser el admin del area o va a hacer un usuario normal 
-- luego cuando se cree un proyecto se debe agregar usuarios a ese proyecto y alli si se debe pedir si va ser "Revisor" o "Editor"
select *from usuarios_areas ua ;
select * from roles r ;


--Crear la Nueva columna rol_area 
--si es true significa que es admin de esa area 
--no hay que borrar el id_rol de momento, hay que hacer que los dos trabajen en paralelo y de a poco ir borrando esa dependencia

alter table usuarios_areas 
add column rol_area bool;
update usuarios_areas set rol_area = true where id_rol =1;


alter table usuarios_areas  alter column rol_area set default false;
alter table usuarios_areas alter column rol_area set not null;


ALTER TABLE usuarios_areas DROP CONSTRAINT usuarios_areas_pkey ;

ALTER TABLE usuarios_areas  
DROP COLUMN id_rol;

--crear una tabla para los participantes de un proyecto 
drop table participantes;

create table participantes(
	Id_participantes int generated always as identity,
	fecha_creacion  TIMESTAMPTZ DEFAULT Now(),
	Id_rol int not null,
	Id_relacion_usu_ar int not null,
	Id_grupo int not null,
	Estado bool not null default true,
	primary Key(Id_participantes)
);

create table grupo_proyecto(
	Id_parti_proyect int generated always as identity,
	fecha_creacion  TIMESTAMPTZ DEFAULT Now(),
	Id_proyecto int not null,
	Estado bool not null default true,
	primary Key(Id_parti_proyect)
);


select * from proyectos p ;
select * from roles r ;
select * from usuarios_areas ua ;
--hacer primary key el campo id_relacion de usuarios areas
ALTER TABLE usuarios_areas ADD PRIMARY KEY (id_relacion);

--conectar la tabla participantes_proyecto con la tabla proyecto
alter table grupo_proyecto add constraint FK_Proyecto_Grupo foreign key (Id_proyecto) references proyectos(id_proyecto);
alter table participantes add constraint FK_Grupo_Participantes foreign key (Id_grupo) references grupo_proyecto(Id_parti_proyect);
alter table participantes add constraint FK_Participante_Rol foreign key (Id_rol) references roles(id_rol);

alter table participantes add constraint FK_Participante_Area 
foreign key (Id_relacion_usu_ar) references usuarios_areas(id_relacion);

--de momento dejar a un lado la lista de participantes porque hasta ahora todos los del area pueden acceder al proyecto
--(ovbiamente aun no tienen roles definidos)

-----------------------[EN DESARROLLO LOS PARTICIPANTES Y SUS ROLES]--------------------


--7/30/2023
----------------------[FLUJO DE UN PROYECTO]---------------------------
--crear tabla flujo_proyecto
--el Estado es para saber si esta activo o inactivo este flujo
--el Estado_Nivel es para saber si este flujo ya se encuentra activo, es decir se envio al siguiente nivel.
create table flujo_proyecto(
	Id_flujo int generated always as identity,
	fecha_creacion  TIMESTAMPTZ DEFAULT Now(),
	Id_proyecto int not null,
	Estado bool not null default true,
	Estado_Nivel bool not null default false,
	primary Key(Id_flujo)
);
select * from proyectos p ;

--conectar la tabla flujo proyecto con el proyecto 
alter table flujo_proyecto add constraint FK_Proyecto_Flujo 
foreign key (Id_proyecto) references proyectos(id_proyecto);

--crear la tabla para los niveles de un flujo 
create table Niveles_Proyecto(
	Id_Niveles_pro int generated always as identity,
	Id_Departamento int not null,
	Id_Flujo int not null,
	fecha_creacion  TIMESTAMPTZ DEFAULT Now(),
	Nivel int not null,
	Tipo_Nivel int not null,
	Estado bool not null default true,
	primary Key(Id_Niveles_pro)
);
select * from area_departamental ad ;

--conectar la tabla Niveles_Proyecto  con el flujo
alter table Niveles_Proyecto add constraint FK_Nivel_Flujo
foreign key (Id_Flujo) references flujo_proyecto(Id_flujo);

--conectar la tabla niveles_proyecto con la tabla area 
alter table Niveles_Proyecto add constraint FK_Nivel_Area
foreign key (Id_Departamento) references area_departamental(id_area);

--crear tabla para los tipos de niveles que van existir ejemplo: Elaboracion, Revision, Publicacion,
create table tipos_niveles(
	Id_tipo_nivel int generated always as identity,
	Tipo_nivel varchar(200) not null unique,
	Descripcion varchar(200) not null unique,
	Estado bool not null default true,
	fecha_creacion  TIMESTAMPTZ DEFAULT Now(),
	
	
	Id_Departamento int not null,
	Id_Flujo int not null,
	
	Nivel int not null,
	Tipo_Nivel int not null,
	primary Key(Id_Niveles_pro)
);

drop table niveles;
--crear tabla niveles 
--la cardinalidad_muchos significa si el nivel aceptara varias areas en ese nivel
--el nivel_inicio es para saber si este nivel va a ser un nodo cabecera de flujo
--el nivel_final es para saber si este nivel va a ser cierre de flujo
create table niveles(
	id_nivel int generated always as identity,
	titulo varchar(200) not null unique,
	descripcion varchar(200) not null unique,
	fecha_creacion TIMESTAMPTZ default Now(),
	cardinalidad_muchos bool not null default false,
	Estado bool not null default true,
    primary key(id_nivel)
);
--procedure para crear los niveles 
Create or Replace Procedure Crear_Nivel(p_titulo varchar(200),
										p_descripcion varchar(200),
										p_cardinalidad bool
										 )
Language 'plpgsql'
AS $$
Begin
	insert into niveles(titulo,descripcion,cardinalidad_muchos )values
	(p_titulo,p_descripcion, p_cardinalidad);
COMMIT;
END;
$$;

select * from niveles;
delete from niveles;


DROP FUNCTION ver_niveles() ;
--funcion para ver los niveles 
create or replace function ver_niveles()
	returns table (
		r_id_nivel int, r_titulo varchar(200), r_descripcion varchar(200), r_cardiniladad bool,r_estado bool
	)
	language 'plpgsql'
	as 
	$BODY$
	begin
		return query 
		select n.id_nivel, n.titulo, n.descripcion,n.cardinalidad_muchos ,n.estado from niveles n;
	end;
	$BODY$;

select * from ver_niveles();
select * from niveles;
--trigger para crear un nivel que no vaya en blanco jijij ja 
create or replace function insert_nivel() returns trigger 
as 
$$
begin 
		if trim(new.titulo)='' then
			raise exception 'Titulo no puede ser vacio';
		end if;
	if trim(new.descripcion)='' then
			raise exception 'Descripcion no puede ser vacio';
		end if;
return new;
end
$$
language 'plpgsql';
--Crear la funcion para ejecutar el trigger 
create trigger Tr_Insert_level
before insert 
on niveles
for each row 
execute procedure insert_nivel();

--crear la tabla jerarquias_niveles y conectarla con niveles 
--aqui hay que agregar un campo para especificar cual es el nodo cabezera de la jerarquia 
create table jerarquias_niveles(
	id_jerarquia int generated always as identity,
	id_tipo_jerarquia int not null,
	fecha_creacion TIMESTAMPTZ default Now(),
	id_nivel_padre int not null,
	id_nivel_hijo int not null,
	estado bool not null default true,
    primary key(id_jerarquia)
);
select * from niveles n ;


alter table jerarquias_niveles 
add column id_cabecera int;

 alter table jerarquias_niveles alter column id_cabecera set not null;

select * from niveles n ;
select * from jerarquias_niveles;

alter table jerarquias_niveles add constraint FK_ID_Nivel_Padre
foreign key (id_nivel_padre) references niveles(id_nivel);

alter table jerarquias_niveles add constraint FK_ID_Nivel_Hijo
foreign key (id_nivel_hijo) references niveles(id_nivel);

alter table jerarquias_niveles add constraint FK_ID_Nivel_Cabecera
foreign key (id_cabecera) references niveles(id_nivel);

--crear la tabla tipos de nivel 
drop table tipos_nivel;
create table tipos_jerarquia(
	id_tipo int generated always as identity,
	titulo_nivel varchar(500) not null unique,
	fecha_creacion TIMESTAMPTZ default Now(),
	estado bool not null default true,
	primary key (id_tipo)
);
--conectar la tabla jerarquia niveles con tipos niveles 
alter table jerarquias_niveles add constraint FK_ID_Tipo_jerarquia
foreign key (id_tipo_jerarquia) references tipos_jerarquia(id_tipo);

select * from jerarquias_niveles;
select * from tipos_jerarquia tj ;

select * from niveles n ;

select * from ver_niveles_activos();

--crear una funcion que solo retorne los niveles que estan con estado true 
create or replace function ver_niveles_activos()
	returns table (
		r_id_nivel int, r_titulo varchar(200), r_descripcion varchar(200), r_cardiniladad bool,r_estado bool
	)
	language 'plpgsql'
	as 
	$BODY$
	begin
		return query 
		select n.id_nivel, n.titulo, n.descripcion,n.cardinalidad_muchos ,n.estado from niveles n where estado =true ;
	end;
	$BODY$;


--insertar flujo de niveles 
select * from jerarquias_niveles;
select * from tipos_jerarquia tj ;


Create or Replace Procedure Crear_Tipo_Jerarquias(p_titulo varchar(200)
										 )
Language 'plpgsql'
AS $$
Begin
	insert into tipos_jerarquia(titulo_nivel)values
	(p_titulo);
COMMIT;
END;
$$;

--aqui crear un proceso almacenado para crear el flujo de trabajo primero almacenar el id del tipo de jerarquia creado 
Create or Replace Procedure Crear_Jerarquias_Niveles(p_id_nivel_padre int, p_id_nivel_hijo int, p_id_cabecera int
										 )
Language 'plpgsql'
AS $$
declare 
	p_id_tipo int;
begin
	select into p_id_tipo id_tipo from tipos_jerarquia order by id_tipo desc;
	insert into jerarquias_niveles(id_tipo_jerarquia,id_nivel_padre,id_nivel_hijo,id_cabecera)
	values
	(p_id_tipo,p_id_nivel_padre,p_id_nivel_hijo,p_id_cabecera);

COMMIT;
END;
$$;

delete from tipos_jerarquia;
delete from jerarquias_niveles;

select * from niveles n ;
select * from jerarquias_niveles jn ;
select * from tipos_jerarquia tj2 ;



select id_tipo  from tipos_jerarquia tj order by id_tipo desc;

--AS $$
--declare
--	ID_A int =0;
--Begin
--	insert into area_departamental(nombre_area,logo_url,cabezera)values
--	(p_nombres,p_logo_area,false);
--	select into ID_A id_area from area_departamental where nombre_area=p_nombres;


--funcion que retorne una tabla con todos los tipos de flujos existentes
select * from tipos_jerarquia tj;

create or replace function Lista_tipos_jerarquias()
returns table
(
	r_id_tipo int, r_titulo_nivel varchar(800), r_fecha varchar(800), r_estado bool
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select id_tipo ,titulo_nivel ,cast(TO_CHAR(fecha_creacion, 'DD-MON-YYYY') as varchar(500)) ,estado  from tipos_jerarquia order by fecha_creacion asc;
end;
$BODY$


--listar los tipos de jerarquias con estado true 
create or replace function Lista_tipos_jerarquias_true()
returns table
(
	r_id_tipo int, r_titulo_nivel varchar(800), r_fecha varchar(800), r_estado bool
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select id_tipo ,titulo_nivel ,cast(TO_CHAR(fecha_creacion, 'DD-MON-YYYY') as varchar(500)) ,estado  from tipos_jerarquia where estado =true order by fecha_creacion asc;
end;
$BODY$

select * from Lista_tipos_jerarquias();


cast(TO_CHAR(fecha_creacion, 'DD-MON-YYYY') as varchar(500))

--funcion para ver la estructura de una jerarquia 

select n.titulo as padre,
		n.cardinalidad_muchos as padre_cardinalidad,
		n2.titulo as hijo,
		n2.cardinalidad_muchos as hijo_cardinalidad,
		n3.titulo as cabecera ,
		n3.cardinalidad_muchos as cabecera_cardinalidad
from jerarquias_niveles jn
inner join niveles n on jn.id_nivel_padre = n.id_nivel 
inner join niveles n2 on jn.id_nivel_hijo = n2.id_nivel 
inner join niveles n3 on jn.id_cabecera = n3.id_nivel 
where jn.id_tipo_jerarquia =6;


select * from Detalle_jerarquia(4);
 DROP FUNCTION detalle_jerarquia(integer);

create or replace function Detalle_jerarquia(p_id_tipo_j int)
returns table
(
	id int,
	r_titulo_padre varchar(800), r_cardinalidad_padre bool,
	r_titulo_hijo varchar(800), r_cardinalidad_hijo bool, 
	r_titulo_cabecera varchar(800), r_cardinalidad_cabecera bool
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select 
		jn.id_jerarquia ,
		n.titulo as padre,
		n.cardinalidad_muchos as padre_cardinalidad,
		n2.titulo as hijo,
		n2.cardinalidad_muchos as hijo_cardinalidad,
		n3.titulo as cabecera ,
		n3.cardinalidad_muchos as cabecera_cardinalidad
from jerarquias_niveles jn
inner join niveles n on jn.id_nivel_padre = n.id_nivel 
inner join niveles n2 on jn.id_nivel_hijo = n2.id_nivel 
inner join niveles n3 on jn.id_cabecera = n3.id_nivel 
where jn.id_tipo_jerarquia =p_id_tipo_j order by jn.id_jerarquia asc;
end;
$BODY$

select * from niveles n ;
select * from jerarquias_niveles jn where id_tipo_jerarquia =6;

select * from Detalle_jerarquia(4);

select * from Lista_tipos_jerarquias();



----------------------[FLUJO DE UN PROYECTO]-----------------------------
--primero definir el flujo que va a tener un proyecto 
select * from flujo_proyecto fp ;
select * from niveles_proyecto np ;

--eliminar columna tipo nivel de niveles proyecto 
ALTER TABLE niveles_proyecto DROP COLUMN tipo_nivel;

--anadir columna para el id_nivel 
ALTER TABLE niveles_proyecto ADD COLUMN id_nivel int not null;


--anadir id_tipo_jerarquia a la tabla flujo proyecto 
ALTER TABLE flujo_proyecto ADD COLUMN id_tipo_jerarquia int not null;

--conectar la tabla niveles proyecto con niveles 
alter table niveles_proyecto add constraint FK_Niveles_proyectos foreign key (id_nivel) references niveles(id_nivel);

--conectar la tabla flujo proyecto con tipos jerarquias
alter table flujo_proyecto add constraint FK_Tipo_Jerarquia foreign key (id_tipo_jerarquia) references tipos_jerarquia(id_tipo);


--crear una funcion que retorne una tabla con las areas : id_area, y si es cabecera en jerarquia o no
select id_area ,nombre_area, prefijo_departamento ,cabezera  from area_departamental ad ;


create or replace function Areas_para_flujo(p_cabezera bool)
returns table
(
	r_id_area int, r_nombre_area varchar(500), r_prefijo varchar(100), r_cabezera bool
)
language 'plpgsql'
as
$BODY$
begin
	if (p_cabezera) then 
		return query
		select id_area ,nombre_area, prefijo_departamento ,cabezera  from area_departamental ad where estado =true and cabezera =true ;
		else 
		return query 
		select id_area ,nombre_area, prefijo_departamento ,cabezera  from area_departamental ad where estado =true;
	end if;
end;
$BODY$

select * from Areas_para_flujo(false);

select * from tipos_jerarquia tj where id_tipo =4;
select *from 



select * from Detalle_jerarquia(6);

select * from Detalle_Flujo(6);

 DROP FUNCTION detalle_flujo(integer) ;
--Crear una funcion que retorne una tabla con el flujo que selecciono en orden desde cabecera con su id de nivel y su cardilaidad hasta el final
create or replace function Detalle_Flujo(p_id_tipo_j int)
returns table
(
	id_nivel int,
	r_titulo_nivel varchar(800), 
	r_cardinalidad_nivel bool, 
	r_num int
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select x.nivel, x.cabecera, x.cabecera_cardinalidad ,cast(ROW_NUMBER() OVER(ORDER BY (SELECT 1))as int) from
			((select 
				n3.id_nivel as nivel,
				n3.titulo as cabecera ,
				n3.cardinalidad_muchos as cabecera_cardinalidad
				from jerarquias_niveles jn
				inner join niveles n3 on jn.id_cabecera = n3.id_nivel 
				where jn.id_tipo_jerarquia =p_id_tipo_j order by jn.id_jerarquia  asc limit 1)
			union all
			(select 
				n2.id_nivel as nivel_hijo,
				n2.titulo as hijo,
				n2.cardinalidad_muchos as hijo_cardinalidad
				from jerarquias_niveles jn
				inner join niveles n on jn.id_nivel_padre = n.id_nivel 
				inner join niveles n2 on jn.id_nivel_hijo = n2.id_nivel 
				inner join niveles n3 on jn.id_cabecera = n3.id_nivel 
		where jn.id_tipo_jerarquia =p_id_tipo_j order by jn.id_jerarquia asc))as x;
end;
$BODY$

select * from niveles n 

select 
		n3.id_nivel as nivel,
		n3.titulo as cabecera ,
		n3.cardinalidad_muchos as cabecera_cardinalidad
		from jerarquias_niveles jn
		inner join niveles n3 on jn.id_cabecera = n3.id_nivel 
		where jn.id_tipo_jerarquia =6 order by jn.id_jerarquia  asc limit 1


		---esta parece que funka
		select x.nivel, x.cabecera, x.cabecera_cardinalidad ,ROW_NUMBER() OVER(ORDER BY (SELECT 1)) from
			((select 
				n3.id_nivel as nivel,
				n3.titulo as cabecera ,
				n3.cardinalidad_muchos as cabecera_cardinalidad
				from jerarquias_niveles jn
				inner join niveles n3 on jn.id_cabecera = n3.id_nivel 
				where jn.id_tipo_jerarquia =6 order by jn.id_jerarquia  asc limit 1)
			union all
			(select 
				n2.id_nivel as nivel_hijo,
				n2.titulo as hijo,
				n2.cardinalidad_muchos as hijo_cardinalidad
				from jerarquias_niveles jn
				inner join niveles n on jn.id_nivel_padre = n.id_nivel 
				inner join niveles n2 on jn.id_nivel_hijo = n2.id_nivel 
				inner join niveles n3 on jn.id_cabecera = n3.id_nivel 
		where jn.id_tipo_jerarquia =6 order by jn.id_jerarquia asc))as x;
		
		


select * from
			((select id_area,id_area,nombre_area,logo_url,cabezera from area_departamental where id_area=ID_Cabecera)
			union all
			(select ad.id_area,na.id_area_padre,ad.nombre_area,ad.logo_url,ad.cabezera from niveles_areas na
			inner join area_departamental ad on na.id_area_hijo =ad.id_area 
			where na.cabezera=ID_Cabecera
			order by na.id_nivel asc))as x;
			
select * from proyectos p where id_proyecto = 27

select * from area_departamental ad where id_area = 61;
select * from Detalle_Flujo(6);


--datos de un area segun su id xd 
--funcion que retorne una tabla con los datos xd, id, nombre, si es cabzera 

select id_area,nombre_area ,cabezera  from area_departamental ad where id_area = 61



create or replace function Data_area_id(p_id int)
returns table
(
	r_id_area int,
	r_nombre_area varchar(800), 
	r_cabecera bool
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select id_area,nombre_area ,cabezera  from area_departamental ad where id_area = p_id;
end;
$BODY$

select * from Data_area_id(61);

select * from tipos_jerarquia tj 



--procedimiento almanecanado para guardar el flujo de un proyecto en la tablas 


select * from flujo_proyecto fp ;
Create or Replace Procedure Crear_flujo_Proyecto(p_id_proyecto int,
										p_id_tipo int,
										p_data JSON
										  )
Language 'plpgsql'
AS $$
declare
	p_p_data JSON;
	ID_F int =0;
	p_id_departamtento int;
	p_id_nivel int;
	p_nivel int;
begin
	--primero se cre el flujo del proyecto
	insert into flujo_proyecto (id_proyecto,id_tipo_jerarquia)values
	(p_id_proyecto,p_id_tipo);
	--luego se selecciona ese id creado 
	select into ID_F id_flujo  from flujo_proyecto fp order by id_flujo desc limit 1 ;
	--y se procede a recoorrer el json para guardar los niveles segun el ID 
	
	FOR p_p_data IN SELECT * FROM json_array_elements(p_data)
    loop
       p_id_departamtento := (p_p_data ->> 'id_area_f')::integer;
       p_id_nivel  := (p_p_data ->> 'id_nivel_f')::integer;
       p_nivel  := (p_p_data ->> 'nivel')::integer;
	    --se inserta los valores de la tabla segun el json
    	insert into niveles_proyecto(id_departamento,id_flujo,id_nivel,nivel)
		values(p_id_departamtento,ID_F,p_id_nivel,p_nivel);
    end loop;
	COMMIT;	
END;
$$;


 EXCEPTION
    -- Si ocurre algún error, revierte la transacción
    WHEN OTHERS THEN
        ROLLBACK;
        raise;


--flujo_proyecto
--niveles_proyecto

select * from flujo_proyecto fp ;
select * from niveles_proyecto np ;


--procedure para crear los niveles de los proyecots 
Create or Replace Procedure crear_niveles_proyectos(p_id_departamtento int,
										p_id_nivel int,
										p_nivel int)
Language 'plpgsql'
AS $$
declare
	ID_F int =0;
Begin
	
	select into ID_F id_flujo  from flujo_proyecto fp order by id_flujo desc limit 1 ;
	insert into niveles_proyecto(id_departamento,id_flujo,id_nivel,nivel)
	values(p_id_departamtento,ID_F,p_id_nivel,p_nivel);
COMMIT;
END;
$$;





select * from
	(select p.titulo,case when ua.rol_area then cast('Admin' as varchar(100)) else cast('Not admin' as varchar(100)) end ,p.subir_docs  from proyectos p 
	inner join area_departamental ad on p.id_area_responsable =ad.id_area 
	inner join usuarios_areas ua on ad.id_area =ua.id_area 
		where cast(ua.id_usuario as varchar(500))=p_idu and p.id_proyecto=p_id_proyecto) as x inner join
	(select case when COUNT(*)>0 then true else false end as TieneFLujo from flujo_proyecto fp 
	where id_proyecto = p_id_proyecto and estado =true ) as y on 1=1;
end;
$BODY$

select * from proyectos p ;

select * from rol_proyecto('c09cda3f-0346-4243-8e59-82d8741e32b1',27);

--hacer una funcion que retorne todas las opciones disponibles de un proyecto 
--es decir Documentos,VerFLujo,Comentarios,etc 


select * from
	(select p.titulo,case when ua.rol_area then cast('Admin' as varchar(100)) else cast('Not admin' as varchar(100)) end ,p.subir_docs  from proyectos p 
	inner join area_departamental ad on p.id_area_responsable =ad.id_area 
	inner join usuarios_areas ua on ad.id_area =ua.id_area 
		where cast(ua.id_usuario as varchar(500))='c09cda3f-0346-4243-8e59-82d8741e32b1' and p.id_proyecto=27) as x inner join
	(select case when COUNT(*)>0 then true else false end as TieneFLujo from flujo_proyecto fp 
	where id_proyecto = 27 and estado =true ) as y on 1=1;



select 
		case when x.subir_docs then 'Documentos' else 'Editor de texto' end as Primera_OP, 
		case when count(*)>0 then 'Guias' else '' end as Segunda_OP, 
from
	(select p.titulo,case when ua.rol_area then cast('Admin' as varchar(100)) else cast('Not admin' as varchar(100)) end ,p.subir_docs  from proyectos p 
	inner join area_departamental ad on p.id_area_responsable =ad.id_area 
	inner join usuarios_areas ua on ad.id_area =ua.id_area 
		where cast(ua.id_usuario as varchar(500))='c09cda3f-0346-4243-8e59-82d8741e32b1' and p.id_proyecto=27) as x inner join
	(select case when COUNT(*)>0 then true else false end as TieneFLujo from flujo_proyecto fp 
	where id_proyecto = 27 and estado =true ) as y on 1=1;


--funcion para ver el flujo que tiene un proyecto 
select * from flujo_proyecto fp where id_proyecto =27;
select * from niveles_proyecto np ;


select id_flujo  from flujo_proyecto fp where id_proyecto =27 and estado =true;



create or replace function ver_FLujo_Proyecto(p_id_proyecto int)
returns table
(
	Area_id int,NombreArea varchar(200),Nivel varchar(500), Numero int
)
language 'plpgsql'
as
$BODY$
declare
	p_ID_Flujo int;
begin
	select into p_ID_Flujo id_flujo  from flujo_proyecto fp where id_proyecto =p_id_proyecto and estado =true;
	return query
	--aqui retornar la tabla
	select ad.id_area ,ad.nombre_area ,n.titulo ,np.nivel 
	from niveles_proyecto np
	inner join area_departamental ad on np.id_departamento =ad.id_area 
	inner join niveles n ON np.id_nivel =n.id_nivel 
	where np.id_flujo =p_ID_Flujo
	order by np.nivel asc;
end;
$BODY$



select * from ver_FLujo_Proyecto(27);


select ad.id_area ,ad.nombre_area ,n.titulo ,np.nivel 
from niveles_proyecto np
inner join area_departamental ad on np.id_departamento =ad.id_area 
inner join niveles n ON np.id_nivel =n.id_nivel 
where np.id_flujo =13
order by np.nivel asc
;

select * from proyectos p ;
select * from documentos_proyectos dp where id_proyecto =24;

--trigger que verifique si ya existe un documento activo en el proyecto, entonces cambiarlo a false 
--para que en el momento que se suba el nuevo entonces lo reemplaze
--tambien agregar un nuevo campo que sea para andir un comentario sobre lo que se esta subiendo, similar a las guias
create or replace function Subir_documentos_proyecto() returns trigger 
as 
$$
---Declarar variables
declare
	numero_documentos bool;
begin
	select into numero_documentos case when count(*) >=1 then true else false end as Existencia from documentos_proyectos dp where dp.id_proyecto =new.id_proyecto;
	if numero_documentos then 
		update documentos_proyectos set estado = false where id_proyecto =new.id_proyecto;
	end if;
	 -- Si ocurre algún error, lanza una excepción
	if trim(new.Descripcion)='' then
			raise exception 'Descripcion no puede ser vacio';
		end if;
	RETURN new;
	
    EXCEPTION
        WHEN OTHERS THEN
            -- Realiza un rollback explícito para deshacer los cambios
            -- hechos en esta función del trigger
            RAISE EXCEPTION 'Error en el trigger: %', SQLERRM;
            ROLLBACK;
            RETURN NULL; -- Opcionalmente, podrías retornar NULL para indicar que el trigger falló		
end
$$
language 'plpgsql';
--update area_departamental  set logo_url= '/img/Home/logo-fci-1.jpg' where id_area = 1



create trigger AgregarDOCS
before insert 
on documentos_proyectos
for each row 
execute procedure Subir_documentos_proyecto();

select * from documentos_proyectos dp ;
delete from documentos_proyectos ;
--agregar un campo "descripcion para el documento del proyecto"
alter table documentos_proyectos 
add column Descripcion varchar(100);

alter table documentos_proyectos alter column Descripcion set not null;

--funcion que retorne los borradores de un proyecto 
--siempre y cuando esten en false 

select dp.url_doc , cast(TO_CHAR(dp.fecha_creacion, 'DD-MON-YYYY') as varchar(500)),dp.id_documento ,dp.descripcion from documentos_proyectos dp 
where id_proyecto = 24 and dp.estado =false order by dp.id_documento  asc;


select * from ver_docs(24);
select *  from ver_borradores_proyecto(24);

select * from documentos_proyectos dp 

create or replace function ver_borradores_proyecto(p_id_proyecto int)
returns table
(
	d_url varchar(800), d_fecha varchar(500), d_id int, d_descripcion varchar(500)
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select dp.url_doc , cast(TO_CHAR(dp.fecha_creacion, 'DD-MON-YYYY') as varchar(500)),dp.id_documento ,dp.descripcion from documentos_proyectos dp 
	where id_proyecto = p_id_proyecto and dp.estado =false order by dp.id_documento  asc;	

end;
$BODY$

--crear tabla para los estados del nivel
create table estado_nivel(
	id_estado int generated always as identity,
	estado bool not null default true,
	fecha TIMESTAMPTZ DEFAULT Now(),
	observacion varchar(500) not null default 'Sin novedades',
	id_nivel int not null,
	estado_nivel varchar(50) not null,
		primary key (id_estado)
);
select * from niveles_proyecto np ;
select * from estado_nivel;
--alter table usuarios_areas add constraint id_area foreign key (id_area) references area_departamental(id_area);
--alter table estado_nivel add constraint FK_ID_NIVel foreign key (id_nivel) references niveles_proyecto(id_niveles_pro);

--funcion para ver un proyecto tiene niveles 
select * from niveles_proyecto np ;
select * from proyectos p 
select * from flujo_proyecto fp ;

--segun el id de un proyecto 
select * from 
proyectos p 
inner join flujo_proyecto fp ON p.id_proyecto =fp.id_proyecto 
inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
where p.id_proyecto =27;



create or replace function data_proyect(idu varchar(500))
returns table
(
	r_id_p int 
)
language 'plpgsql'
as
$BODY$
begin
	return query
		select p.id_proyecto  from 
		proyectos p 
		inner join flujo_proyecto fp ON p.id_proyecto =fp.id_proyecto 
		inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
		where p.id_proyecto =cast(idu as int);
	end;
$BODY$

select * from data_proyect('27');

select 
en.id_estado ,en.estado ,en.fecha ,en.observacion ,en.id_nivel ,en.estado_nivel,ad.id_area ,ad.nombre_area ,np.nivel, true as click
from proyectos p 
inner join flujo_proyecto fp on p.id_proyecto =fp.id_proyecto 
inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
inner join estado_nivel en on np.id_niveles_pro =en.id_nivel 
inner join area_departamental ad on np.id_departamento =ad.id_area 
where p.id_proyecto =27 and fp.estado = true;	

select * from estado_nivel en ;
--funcion que retorne los niveles actuales de un proyecto
--es decir, elaboracion->revision->publicacion
--con sus estados: "Rechazadado", "Aprobado", "Publicado", etc 
--si el proyecto no tiene estados de nivel es porque apenas esta en elaboracion y no ha salido de alli.
select * from niveles_estado_proyecto(30);
DROP FUNCTION niveles_estado_proyecto(integer);
create or replace function niveles_estado_proyecto(p_id_proyecto int)
returns table
(
	r_id_estado int, r_estado bool, r_fecha_estado varchar(500), r_observacion varchar(200),
	r_id_nivel int, r_estado_nivel varchar(200), r_id_area int, r_nombre_area varchar(200), r_nivel int, click bool,
	r_tipo_nivel varchar(500)
)
language 'plpgsql'
as
$BODY$
declare
	T_niveles bool;
begin
	select  into T_niveles
	case when count(*)>=1 then true else false end 
	from proyectos p 
	inner join flujo_proyecto fp on p.id_proyecto =fp.id_proyecto 
	inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
	inner join estado_nivel en on np.id_niveles_pro =en.id_nivel 
	where p.id_proyecto =p_id_proyecto and fp.estado = true;	

	--Si es true es porque tiene niveles entonces hay que retornar la data con todo en true 
	if(T_niveles) then
	return query
	select 
	en.id_estado ,en.estado ,cast(TO_CHAR(en.fecha, 'DD-MON-YYYY') as varchar(500)),en.observacion ,en.id_nivel ,en.estado_nivel,ad.id_area ,ad.nombre_area ,np.nivel, cast(true as bool) ,  n.titulo 
	from proyectos p 
	inner join flujo_proyecto fp on p.id_proyecto =fp.id_proyecto 
	inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
	inner join estado_nivel en on np.id_niveles_pro =en.id_nivel 
	inner join area_departamental ad on np.id_departamento =ad.id_area 
	inner join niveles n on np.id_nivel =n.id_nivel 

	where p.id_proyecto =p_id_proyecto and fp.estado = true order by np.nivel asc ;		
	--sino es xq aun esta en elaboracion, entonces retornar data solo con dicho estado
	else 
	return query
			select 
	 cast(0 as int),cast(false as bool),cast(TO_CHAR(p.fecha_creacion, 'DD-MON-YYYY') as varchar(500)),cast('En elaboracion' as varchar(100)),
	 cast(0 as int),cast('No enviado' as varchar(100)),ad.id_area ,ad.nombre_area ,np.nivel , cast(false as bool), n.titulo 
		from proyectos p 
		inner join flujo_proyecto fp ON p.id_proyecto =fp.id_proyecto 
		inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
		inner join area_departamental ad ON np.id_departamento =ad.id_area 
		inner join niveles n on np.id_nivel =n.id_nivel 
		where p.id_proyecto =p_id_proyecto and fp.estado = true and np.nivel =0 order by np.nivel asc ;	
	end if;
end;
$BODY$



select 
	 cast(0 as int),cast(false as bool),p.fecha_creacion   ,cast('En elaboracion' as varchar(100)),
	 cast(0 as int),cast('No enviado' as varchar(100)),ad.id_area ,ad.nombre_area ,np.nivel , cast(false as bool)
from proyectos p 
inner join flujo_proyecto fp ON p.id_proyecto =fp.id_proyecto 
inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
inner join area_departamental ad ON np.id_departamento =ad.id_area 
inner join niveles n on np.id_nivel =n.id_nivel 
where p.id_proyecto =27 and fp.estado = true and np.nivel =0;		




select * from proyectos p;

select 
	en.id_estado ,en.estado ,en.fecha ,en.observacion ,en.id_nivel ,en.estado_nivel,ad.id_area ,ad.nombre_area ,np.nivel, true as click
	from proyectos p 
	inner join flujo_proyecto fp on p.id_proyecto =fp.id_proyecto 
	inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
	inner join estado_nivel en on np.id_niveles_pro =en.id_nivel 
	inner join area_departamental ad on np.id_departamento =ad.id_area 
	where p.id_proyecto =27 and fp.estado = true;	
	

select * from data_proyect('24');

select * from estado_nivel en ;

select * from proyectos p 
-----------------------------------------------------[SUBIR DE NIVEL UN PROYECTO]--------------------------------------------
--para subir un proyecto de nivel se necesita primero
--1.- haber ingresado a la tabla estado_nivel el nivel de elaboracion con la fecha en que se ingresa el flujo
--esa inserccion va cuando se crea el flujo del proyecto
--este es el proceso que se debe editar para que esto se efectue 
Create or Replace Procedure Crear_flujo_Proyecto(p_id_proyecto int,
										p_id_tipo int,
										p_data JSON
										  )
Language 'plpgsql'
AS $$
declare
	p_p_data JSON;
	ID_F int =0;
	p_id_departamtento int;
	p_id_nivel int;
	p_nivel int;
	p_id_nivel_flujo int;
	p_primer_nivel int;
	p_ultimo_historial int;
	es_reforma bool;
	peso DECIMAL(5, 1);
	Prefijo_proyect varchar(50);
	Prefijo_area varchar(50);
	Prefijo_categoria varchar(50);
begin
	--primero se cre el flujo del proyecto
	insert into flujo_proyecto (id_proyecto,id_tipo_jerarquia)values
	(p_id_proyecto,p_id_tipo);
	--luego se selecciona ese id creado 
	select into ID_F id_flujo  from flujo_proyecto fp order by id_flujo desc limit 1 ;
	--y se procede a recoorrer el json para guardar los niveles segun el ID 
	
	FOR p_p_data IN SELECT * FROM json_array_elements(p_data)
    loop
       p_id_departamtento := (p_p_data ->> 'id_area_f')::integer;
       p_id_nivel  := (p_p_data ->> 'id_nivel_f')::integer;
       p_nivel  := (p_p_data ->> 'nivel')::integer;
	    --se inserta los valores de la tabla segun el json
    	insert into niveles_proyecto(id_departamento,id_flujo,id_nivel,nivel)
		values(p_id_departamtento,ID_F,p_id_nivel,p_nivel);
    end loop;
   --ahora se necesita registrar el estado del nivel que seria el primero: elaboracion -> 'En elaboracion'
   --para ello primero se toma el ultimo flujo creado del proyecto
   select into p_id_nivel_flujo id_flujo  
	from flujo_proyecto fp
	where fp.id_proyecto =p_id_proyecto and fp.estado =true order by id_flujo asc limit 1;
	--ahora se toma el primer nivel de ese flujo para insertarlo en el estado nivel 
	select into p_primer_nivel id_niveles_pro  from niveles_proyecto np where np.id_flujo = p_id_nivel_flujo and estado =true order by nivel asc limit 1;
	--y se inserta ese p_primer_nivel en los estados del nivel con la observacion -> "EN elaboracion"
	insert into  estado_nivel (id_nivel,observacion,estado_nivel) values (p_primer_nivel, 'Se empieza la elaboracion','Sin enviar');
	--aqui insertar el historial del proyecto cuando se crea un flujo para el proyecto xd

	insert into historial_proyecto (detalle,boton,tipo,id_proyecto,Descripcion, titulo)
	values ('Se crea un nuevo flujo para el proyecto',true,3,p_id_proyecto,'Creación de flujo para el proyecto','Nuevo Flujo');
	--ahora obtener el id de la ultima historia proyecto para conectar ese historial con el flujo 
	--p_ultimo_historial
	select id_historial into  p_ultimo_historial from historial_proyecto hp where hp.id_proyecto =p_id_proyecto order by id_historial desc limit 1;
	--ahora insertar eso en la tabla flujo_historial para empatar el flujo rechazado con el id de la historia 
	insert into historial_flujo(id_flujo,id_historial) values (p_id_nivel_flujo,p_ultimo_historial );
	--aqui obtener si el proyecto es reforma para ver si se actualiza la version y el codigo del proyecto?
	select p.reforma into es_reforma from proyectos p where p.id_proyecto =p_id_proyecto;
	--aqui hacer la condicion if para sumar la version del proyecto ssjsj skere modo pija
			if(es_reforma)then
				--obtener el peso del flujo para sumarlo con la version actual del proyecto
				select tj.valor into peso from tipos_jerarquia tj where tj.id_tipo =p_id_tipo;
				--obtener todo los demas datos como el prefijo del proyecto, prefijo de area, prefijo extc sxs y la version actual del proyecto
				--concat(Prefijo_proyect,'-', Prefijo_area,'-',Prefijo_categoria,'-',Version_actual)
				select p.prefijo_proyecto , ad.prefijo_departamento , cp.prefijo_categoria into Prefijo_proyect,Prefijo_area,Prefijo_categoria
				from proyectos p
				inner join area_departamental ad on p.id_area_responsable =ad.id_area
				inner join categorias_proyecto cp on p.id_categoria =cp.id_categoria where p.id_proyecto =p_id_proyecto ;
				--ahora hacer el update a la version del proyecto y al codigo del proyecto 
				update proyectos set versionp =peso+versionp, codigo =concat(Prefijo_proyect,'-', Prefijo_area,'-',Prefijo_categoria,'-',peso+versionp) where id_proyecto =p_id_proyecto;
			end if;
	EXCEPTION
        -- Si ocurre un error en la transacción principal, revertir
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE EXCEPTION 'Ha ocurrido un error en la transacción principal: %', SQLERRM;
END;
$$;

select p.prefijo_proyecto , ad.prefijo_departamento , cp.prefijo_categoria 
from proyectos p
inner join area_departamental ad on p.id_area_responsable =ad.id_area
inner join categorias_proyecto cp on p.id_categoria =cp.id_categoria  ;

select tj.valor  from tipos_jerarquia tj where tj.id_tipo =10;

select * from historial_proyecto hp ;

select * from estado_nivel en ;
--para cojer el ultimo id del flujo que se esta creando 
select id_flujo  
from flujo_proyecto fp
where fp.id_proyecto =27 and fp.estado =true order by id_flujo asc limit 1;
--aqui seleccionar el nivel del fllujo 0 es decir el primero que corresponde a elaboracion y ese registrarlo en niveles proyecto
select id_niveles_pro  from niveles_proyecto np where np.id_flujo = 13 and estado =true order by nivel asc limit 1;

select *  from niveles_proyecto np where np.id_flujo = 13 and estado =true order by nivel asc limit 1;


--borrar todos los datos relacionados con el flujo para realizar las pruebas 
delete from niveles_proyecto np ;
delete from flujo_proyecto ;


--2do para enviarlo al siguiente nivel hay que actualizar el "estado_nivel" de la tabla estado_nivel a "Enviado" cuando sea elaboracion
--3.- Registrar un nuevo estado nivel con el id del siguiente area y la observacion 'Se esta revisando' y estado nivel 'En revision'
--4.- cuando el area que lo esta revisando acepta el documento y lo envia al suigiente nivel se actualiza su estado a 'Revisado' y la observacion 'Sin ninguna observacion'
--5.- En una tabla aparte se debe de guardar el historial del proyecto esa tabla tiene que estar solo pegada al proyecto xq va a ser fuente unica de consultas.
--funcion para mostrar los dos primeros niveles de un proyecto para enviarlo al promximo xdxdxd j0der aun me gusta MAholy 
DROP FUNCTION ver_flujo_proyecto_nivel2(integer);
create or replace function ver_FLujo_Proyecto_nivel2(p_id_proyecto int)
returns table
(
	Area_id int,NombreArea varchar(200),Nivel varchar(500), Numero int, id_nivel int
)
language 'plpgsql'
as
$BODY$
declare
	p_ID_Flujo int;
begin
	select into p_ID_Flujo id_flujo  from flujo_proyecto fp where id_proyecto =p_id_proyecto and estado =true;
	return query
	--aqui retornar la tabla
	select ad.id_area ,ad.nombre_area ,n.titulo ,np.nivel, np.id_niveles_pro 
	from niveles_proyecto np
	inner join area_departamental ad on np.id_departamento =ad.id_area 
	inner join niveles n ON np.id_nivel =n.id_nivel 
	where np.id_flujo =p_ID_Flujo
	order by np.nivel asc limit 2;
end;
$BODY$

select * from proyectos p 
select * from ver_FLujo_Proyecto_nivel2(24);

select * from estado_nivel en ;
select * from flujo_proyecto fp ;
select * from niveles_proyecto np ;

select ad.id_area ,ad.nombre_area ,n.titulo ,np.nivel, np.id_niveles_pro 
	from niveles_proyecto np
	inner join area_departamental ad on np.id_departamento =ad.id_area 
	inner join niveles n ON np.id_nivel =n.id_nivel 
	where np.id_flujo =15
	order by np.nivel asc limit 2;

--al enviar el json con los 2 niveles 
--el 1 se tiene que editar el numero 0 
--el 2 se tiene que ingresar 
select * from estado_nivel en;
---aqui esta el procedimiento almacenado para subir de nivel un proyecto 
Create or Replace Procedure subir_primer_nivel(
										p_data JSON
										  )
Language 'plpgsql'
AS $$
declare
	p_p_data JSON;
	p_id_nivel int;
	p_numero int;
	p_titulo varchar(100);
	p_nombre_area varchar(100);
	p_id_proyecto int;
	p_id_area int;
	p_id_relacion int;
	es_reforma bool;
begin
	FOR p_p_data IN SELECT * FROM json_array_elements(p_data)
    loop
       p_id_nivel := (p_p_data ->> 'id_nivel')::integer;
	   p_numero := (p_p_data ->> 'numero')::integer;
		--preguntar si es nivel 0 es decir elaboracion, de ser asi, editar el nivel 
      	if(p_numero=0)then
      		--editar 
      		update estado_nivel set observacion='Enviado al siguiente nivel', estado_nivel='Enviado', enviando=true
      		where id_nivel = p_id_nivel;
      	else 
      		--sino ingresar un nuevo estado nivel 
      	insert into estado_nivel(id_nivel,estado_nivel) values (p_id_nivel,'En revision');
      	--aqui consultar a que tipo de nivel pertenece ese id_nivel, es decir Revision, Elboracion, ETC y al area que le pertenece para poder insertar en el historial del proyecto
      select n.titulo ,ad.nombre_area , ad.id_area 
      	into p_titulo,p_nombre_area, p_id_area
		from niveles_proyecto np 
		inner join niveles n on np.id_nivel =n.id_nivel 
		inner join area_departamental ad on np.id_departamento = ad.id_area 
		where np.id_niveles_pro = p_id_nivel;
		--aqui obteener el id del proyecto 
		select fp.id_proyecto into p_id_proyecto from
		niveles_proyecto np
		inner join flujo_proyecto fp on np.id_flujo =fp.id_flujo 
		where np.id_niveles_pro = p_id_nivel ;
		--aqui insertar la wea fobe 
		insert into historial_proyecto (detalle,boton,tipo,id_proyecto,Descripcion, titulo)
		values (concat('El proyecto subió al nivel: ',p_titulo, ' que pertenece al area: ',p_nombre_area),false,6,p_id_proyecto,'Subida de niveles','Subir nivel');
		--aqui insertar el usuario administrador de ese nivel xd skere sjjsjs skere 
		--obtener el id de la relacion usuario_area si es administrador del area del que se obtiene el id 
		select ua.id_relacion into p_id_relacion  from usuarios_areas ua where ua.rol_area and ua.estado and ua.id_area =p_id_area;
		--insertar 
		insert into participantes(id_rol,id_relacion_usu_ar,id_proyecto) values (1,p_id_relacion,p_id_proyecto);
      	end if;
    end loop;
	EXCEPTION
        -- Si ocurre un error en la transacción principal, revertir
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE EXCEPTION 'Ha ocurrido un error en la transacción principal: %', SQLERRM;	
END;
$$;

-- a partir de esta consulta debo obtener el peso del flujo
		select tj.valor  from 
		(select fp.id_proyecto as idproyecto from
		niveles_proyecto np
		inner join flujo_proyecto fp on np.id_flujo =fp.id_flujo 
		where np.id_niveles_pro = 94 ) as x inner join flujo_proyecto fp on x.idproyecto = fp.id_proyecto 
		inner join tipos_jerarquia tj on fp.id_tipo_jerarquia = tj.id_tipo 
		order by fp.id_flujo desc limit 1;
	
	
	
	
	select * from tipos_jerarquia tj ;
	select * from flujo_proyecto fp ;
select * from estado_nivel;



select p.reforma  from proyectos p ;

select ua.id_relacion  from usuarios_areas ua where ua.rol_area and ua.estado and ua.id_area =58;


select * from participantes p ;
--consulta para saber el nivel y el area segun el id nivel 
select n.titulo ,ad.nombre_area  
from niveles_proyecto np 
inner join niveles n on np.id_nivel =n.id_nivel 
inner join area_departamental ad on np.id_departamento = ad.id_area 
where np.id_niveles_pro = 107
--obtener el id del proyecto al cual pertenece ese nivel 
select fp.id_proyecto  from
niveles_proyecto np
inner join flujo_proyecto fp on np.id_flujo =fp.id_flujo 
where np.id_niveles_pro = 107 ;






update usuario set nombres=p_nombres, tipo_identificacion= p_tipo_identificacion
where  cast(id_user as varchar(500)) = p_id_user;

--no se podra crear mas niveles 
--ni se podra crear mas jerarquias 
--solo existiran publicacion->revision(s)->publicacion
--lo que se podra hacer es habilitarlas y deshabilitarlas
--en los niveles de jerarquia hay que bloquearlos xq si se parametrizan va ser un dolor de webos xd
--y hay que agregarle un campo estatico para saber si acepta o no publicacion
--si acepta publicacion entonces en ese nivel si se podra editar
--si no solo sera de revision
select * from estado_nivel en ;
select * from niveles_proyecto np ;


select * from proyectos p 

--hacer una funcion que retorne la lista de proyectos en "revision" o 'publicacion' que hallan sido
-- subidos de nivel en el area del actual nivel
--es decir si viene de admision y el area actual es ->Decanato entonces y ya paso de elaboacion a
-- reviison entonces debe aparecer en Decanato
--solo le debe aparecer al admin del area
 --proyecto que se esta poniendo a prueba es el '12345' -> ascendio a revision en Facultad de ciencias Pecurias

select *
from proyectos p 
inner join area_departamental ad on p.id_area_responsable =ad.id_area 
inner join usuarios_areas ua on ad.id_area =ua.id_area 
--el ua rol true es para indicar que es administador del area
inner join flujo_proyecto fp on p.id_proyecto =fp.id_proyecto 
---se filtra dependiendo del area 
inner join niveles_proyecto np 
where ua.rol_area = true and ua.estado =true  and ad.id_area =58


select * from proyectos p 


 --proyecto que se esta poniendo a prueba es el '12345' -> ascendio a revision en Facultad de ciencias Pecurias
select * from area_departamental ad 


--aqui esta todo lo que se necesita para que proyectos que vienen de niveles inferiores se puedan ver en las areas superiores
select * 
from niveles_proyecto np 
inner join estado_nivel en on np.id_niveles_pro =en.id_nivel 
inner join flujo_proyecto fp on np.id_flujo = fp.id_flujo 
inner join proyectos p on fp.id_proyecto =p.id_proyecto 
inner join niveles n on np.id_nivel =n.id_nivel 
where np.id_departamento = 60 and np.estado =true and en.estado =true and en.enviando = false

--hay que agregar un campo en la tabla niveles para saber que niveles puede publicar o revisar y hay que bloquear la opcion de crear mas niveles 

alter table niveles 
add column tipo_nivel int;

--Tipos Niveles
--1 --> Elaboracion 
--2 --> Revision
--3--->Publicacion 

select * from niveles n ;

select * from jerarquias_niveles jn 

update niveles set tipo_nivel=1 where id_nivel =3;
update niveles set tipo_nivel=2 where id_nivel =4;
update niveles set tipo_nivel=2 where id_nivel =9;


--hay que agregar un campo bool al estado del nivel para saber si se encuentra actualmente en ese estado deberia estar marcado como false 
--y cada que se envie a otro nivel cambiaria a true 

 alter table estado_nivel alter column enviando set not null;

alter table estado_nivel  alter column enviando set default false;

alter table estado_nivel 
add column enviando bool;

select * from estado_nivel en 
update estado_nivel set enviando = false where id_estado =2

----------------------------------------------------------------------------------------------------


select * from usuarios_areas ua 


----con esta funcion listar los proyectos cuando suben de area xd sexto Maholy

select * from area_departamental ad ;
select * from proyectos_areas(61,true);

DROP FUNCTION proyectos_areas(integer,boolean) ;

--aregarle un nuevo campo de retorno para saber si es un proyecto en reforma o primera version sjsjs skere modod skere
create or replace function proyectos_areas(p_id_area int, p_is_admin bool)
returns table
(
	p_id_proyecto int, p_titulo varchar(800), p_codigo varchar(100), p_estado bool, p_prefijo varchar(5), p_categoria varchar(100),p_subir bool, p_titulo_nivel varchar(500), p_tipo_nivel int, p_id_niveles_pro int, p_reforma bool, p_estado bool
)
language 'plpgsql'
as
$BODY$
begin
	if(p_is_admin)then 
		return query
		select p.id_proyecto,p.titulo, p.codigo, p.estado,p.prefijo_proyecto, cp.nombre_categoria ,p.subir_docs,cast('Elaboracion'as varchar(500)),cast(1 as int), cast(0 as int), p.reforma, p.estado 
		from proyectos p inner join categorias_proyecto cp on p.id_categoria=cp.id_categoria
		where p.id_area_responsable = p_id_area and  p.publicado = false
		union ALL
		select p.id_proyecto , p.titulo ,p.codigo ,p.estado, p.prefijo_proyecto ,cp.nombre_categoria, p.subir_docs, n.titulo,n.tipo_nivel,np.id_niveles_pro, p.reforma
		from niveles_proyecto np 
		inner join estado_nivel en on np.id_niveles_pro =en.id_nivel 
		inner join flujo_proyecto fp on np.id_flujo = fp.id_flujo 
		inner join proyectos p on fp.id_proyecto =p.id_proyecto 
		inner join niveles n on np.id_nivel =n.id_nivel 
		inner join categorias_proyecto cp on p.id_categoria =cp.id_categoria 
		where np.id_departamento = p_id_area and np.estado =true and en.estado =true and en.enviando = false and p.publicado = false;
	else 
		return query
		select p.id_proyecto,p.titulo, p.codigo, p.estado,p.prefijo_proyecto, cp.nombre_categoria ,p.subir_docs,cast('Elaboracion'as varchar(500)),cast(1 as int), cast(0 as int), p.reforma
		from proyectos p inner join categorias_proyecto cp on p.id_categoria=cp.id_categoria
		where p.id_area_responsable = p_id_area and p.publicado = false;
	end if;
end;
$BODY$


select * from proyectos p where p.id_area_responsable =58;

--cambiar la estructura de la funcion 
		select p.id_proyecto,p.titulo, p.codigo, p.estado,p.prefijo_proyecto, cp.nombre_categoria ,p.subir_docs,cast('Elaboracion'as varchar(500)),cast(1 as int), cast(0 as int)
		from proyectos p inner join categorias_proyecto cp on p.id_categoria=cp.id_categoria
		where p.id_area_responsable = 60 and  p.publicado = false
		union all
		select * from
		(
		select p.id_proyecto , p.titulo ,p.codigo ,p.estado, p.prefijo_proyecto ,cp.nombre_categoria, p.subir_docs, n.titulo,n.tipo_nivel,np.id_niveles_pro 
		from niveles_proyecto np 
		inner join estado_nivel en on np.id_niveles_pro =en.id_nivel 
		inner join flujo_proyecto fp on np.id_flujo = fp.id_flujo 
		inner join proyectos p on fp.id_proyecto =p.id_proyecto 
		inner join niveles n on np.id_nivel =n.id_nivel 
		inner join categorias_proyecto cp on p.id_categoria =cp.id_categoria 
		where np.id_departamento = 60 and np.estado =true and en.estado =true and en.enviando = false and p.publicado = false) as X;
		
	
	
select * from area_departamental ad ;



			select * from
			((select id_area,id_area,nombre_area,logo_url,cabezera from area_departamental where id_area=ID_Cabecera)
			union all
			(select ad.id_area,na.id_area_padre,ad.nombre_area,ad.logo_url,ad.cabezera from niveles_areas na
			inner join area_departamental ad on na.id_area_hijo =ad.id_area 
			where na.cabezera=ID_Cabecera
			order by na.id_nivel asc))as x;



select * from niveles n2 
--se necesita agregar el nivel al que pertenece
select p.id_proyecto , p.titulo ,p.codigo ,p.estado, p.prefijo_proyecto ,cp.nombre_categoria, p.subir_docs, n.titulo,n.tipo_nivel,np.id_niveles_pro 
from niveles_proyecto np 
inner join estado_nivel en on np.id_niveles_pro =en.id_nivel 
inner join flujo_proyecto fp on np.id_flujo = fp.id_flujo 
inner join proyectos p on fp.id_proyecto =p.id_proyecto 
inner join niveles n on np.id_nivel =n.id_nivel 
inner join categorias_proyecto cp on p.id_categoria =cp.id_categoria 
where np.id_departamento = 60 and np.estado =true and en.estado =true and en.enviando = false;



select p.id_proyecto,p.titulo, p.codigo, p.estado,p.prefijo_proyecto, cp.nombre_categoria ,p.subir_docs,cast('Elaboracion'as varchar(500)),cast(1 as int), cast(0 as int)
	from proyectos p inner join categorias_proyecto cp on p.id_categoria=cp.id_categoria
	where p.id_area_responsable = 60;


(select p.id_proyecto , p.titulo ,p.codigo ,p.estado, p.prefijo_proyecto ,cp.nombre_categoria, p.subir_docs, n.titulo,n.tipo_nivel,np.id_niveles_pro 
		from niveles_proyecto np 
		inner join estado_nivel en on np.id_niveles_pro =en.id_nivel 
		inner join flujo_proyecto fp on np.id_flujo = fp.id_flujo 
		inner join proyectos p on fp.id_proyecto =p.id_proyecto 
		inner join niveles n on np.id_nivel =n.id_nivel 
		inner join categorias_proyecto cp on p.id_categoria =cp.id_categoria 
		where np.id_departamento = 60 and np.estado =true and en.estado =true and en.enviando = false)
		union all
		(select p.id_proyecto,p.titulo, p.codigo, p.estado,p.prefijo_proyecto, cp.nombre_categoria ,p.subir_docs,cast('Elaboracion'as varchar(500)),cast(1 as int), cast(0 as int)
		from proyectos p inner join categorias_proyecto cp on p.id_categoria=cp.id_categoria
		where p.id_area_responsable = 60)



select * from proyectos p where id_proyecto =24;


--funcion que retorne el ultimo id del documento de un proyecto xdxd para poder ver el pdf 

select * from documentos_proyectos dp where id_proyecto =24 order by id_documento desc limit 1;


create or replace function doc_id(p_id_pro int)
returns table
(
	r_id int
)
language 'plpgsql'
as
$BODY$
begin
		return query
		select id_documento  from documentos_proyectos dp where id_proyecto =p_id_pro order by id_documento desc limit 1;
end;
$BODY$

select * from doc_id(24);

select * from proyectos p where id_proyecto = 24;
--funcion para aceptar un proyecto en cualquier nivel de revision 
select * from estado_nivel en ;
--enviar el id del ultimo estado nivel que se encuentra el proyecto 
--editar ese id 
--seleccionar el id mayor al actual limit 1  y ese insertarlo como nuevo 

select * from flujo_proyecto fp 
select * from estado_nivel en ;
select * from niveles_proyecto np2  where id_flujo = 15
select * from proyectos p 
--30


select * from proyectos p2 
inner join flujo_proyecto fp2 on p2.id_proyecto =fp2.id_proyecto 
inner join niveles_proyecto np2 on fp2.id_flujo = np2.id_flujo 
inner join niveles n on np2.id_nivel =n.id_nivel 
inner join estado_nivel en2 on np2.id_niveles_pro =en2.id_nivel 
where p2.id_proyecto =30
--escojer el ultimo estado del nivel para poder editarlo segun el id del proyecto
select en.id_estado , en.estado ,en.estado_nivel 
from proyectos p 
inner join flujo_proyecto fp on p.id_proyecto =fp.id_proyecto 
inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
inner join estado_nivel en on np.id_niveles_pro = en.id_nivel  
where p.id_proyecto =30 and en.enviando = false
order by en.id_estado desc limit 1;
--ese id que retorna hay que editarlo
--ahora un script que retorne el id que sigue en el flujo
select np.id_niveles_pro  
from proyectos p 
inner join flujo_proyecto fp on p.id_proyecto =fp.id_proyecto 
inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
inner join estado_nivel en on np.id_niveles_pro = en.id_nivel  
where p.id_proyecto =30
order by en.id_estado desc limit 1;
--este retorna el id del nivel 38 y debe retornar el 39
--script que me seleccione el id siguiente 
select np.id_niveles_pro  
from proyectos p 
inner join flujo_proyecto fp on p.id_proyecto =fp.id_proyecto 
inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
where p.id_proyecto =30 and np.id_niveles_pro >46
order by np.id_niveles_pro  asc limit 1;

select *
from proyectos p
inner join flujo_proyecto fp on p.id_proyecto =fp.id_proyecto 
inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
where p.id_proyecto =30
--este id es el que se tiene que ingresar al estado nivel con la estado en revision 


select * from estado_nivel en ;
delete from estado_nivel where id_estado =5;

--procedimiento almacenado para avanzar un nivel
Create or Replace Procedure subir_niveles(
										p_proyecto_id int,
										p_url_doc varchar(800)
										  )
Language 'plpgsql'
AS $$
declare
	p_id_estado int;
	p_id_niveles_pro int;
	p_id_niveles_pro_insert int;
	p_nivel varchar(500);
	p_nombre_area varchar(500);
	p_id_documento int;
	p_id_area int;
	p_id_relacion int;
begin
	--seleccionar el id a editar xdxdx Maholy aun no te olvido
	select into p_id_estado en.id_estado 
	from proyectos p 
	inner join flujo_proyecto fp on p.id_proyecto =fp.id_proyecto 
	inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
	inner join estado_nivel en on np.id_niveles_pro = en.id_nivel  
	where p.id_proyecto =p_proyecto_id
	order by en.id_estado desc limit 1;
	--editar ese id 
	update estado_nivel set observacion='Sin novedades', estado_nivel='Aceptado', enviando=true
      where id_estado = p_id_estado;
     --aqui tengo que agregar al historial del proyecto que se acepto el documento en este nivel y luego que subio otro nivel
     --primer obtener el nombre del area y el nivel que esta aceptando segun el id del estado que esta editando jaajj saludos 
     select n2.titulo  , ad.nombre_area into p_nivel, p_nombre_area
		from estado_nivel en
		inner join niveles_proyecto np on en.id_nivel = np.id_niveles_pro  
		inner join niveles n2  on np.id_nivel = n2.id_nivel 
		inner join area_departamental ad on np.id_departamento = ad.id_area 
		where en.id_estado =p_id_estado;
	--ahora si registrar el historial del proyecto 
	insert into historial_proyecto (detalle,boton,tipo,id_proyecto,Descripcion, titulo)
	values (concat('El area: ',p_nombre_area, ' aceptó el proyecto en el nivel de: ',p_nivel),false,5,p_proyecto_id,'El proyecto ha sido aceptado','Aceptar nivel');
     --ahora tengo que escojer el nivel despues de este jajaja saludos
	select into p_id_niveles_pro np.id_niveles_pro  
	from proyectos p 
	inner join flujo_proyecto fp on p.id_proyecto =fp.id_proyecto 
	inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
	inner join estado_nivel en on np.id_niveles_pro = en.id_nivel  
	where p.id_proyecto =p_proyecto_id
	order by en.id_estado desc limit 1;
	--ir al siguiente nivel 
	select into p_id_niveles_pro_insert np.id_niveles_pro  
	from proyectos p 
	inner join flujo_proyecto fp on p.id_proyecto =fp.id_proyecto 
	inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
	where p.id_proyecto =p_proyecto_id and np.id_niveles_pro >p_id_niveles_pro
	order by np.id_niveles_pro  asc limit 1;
	--insertar este nuevo nivel como enviando xdxd saludos
     insert into estado_nivel(id_nivel,estado_nivel) values (p_id_niveles_pro_insert,'En revision');
	--ahora tengo que en el historial colocar que el proyecto subio a un nuevo nivel ajaj salu2 j0der no creo que termine para el miercoles j0der
     --primer obtener el nombre del area y el nivel que esta aceptando segun el id del estado que esta editando jaajj saludos 
    --aqui obtener el id del area 
	select n.titulo , ad.nombre_area, ad.id_area  into p_nivel, p_nombre_area, p_id_area
	from niveles_proyecto np 
	inner join niveles n on np.id_nivel = n.id_nivel 
	inner join area_departamental ad on np.id_departamento =ad.id_area 
	where id_niveles_pro = p_id_niveles_pro_insert;
	--ahora si registrar el historial del proyecto 
	insert into historial_proyecto (detalle,boton,tipo,id_proyecto,Descripcion, titulo)
	values (concat('El proyecto subió al nivel: ',p_nivel, ' que pertenece al area: ',p_nombre_area),false,6,p_proyecto_id,'El proyecto sube a un nuevo nivel','Subir nivel');
	--actualizar la url MODIFICADA del campo URLMODIFICADO de DOcumentos PRoyectos segun el id 
	--p_url_doc varchar(800)
	--tAMBIEN actualizar todos los documentos extras segun el id del proyecto a false	
	select  dp.id_documento into p_id_documento from documentos_proyectos dp where dp.id_proyecto =p_proyecto_id and dp.estado ;
	update documentos_proyectos set url_modificado = p_url_doc where id_documento =p_id_documento;
	update documentos_extras set estado = false where id_proyecto =p_proyecto_id;
	--aqui agregar el nuevo usuario administrador del siguiente area a la tabla participantes 
	select ua.id_relacion into p_id_relacion  from usuarios_areas ua where ua.rol_area and ua.estado and ua.id_area =p_id_area;
		--insertar 
		insert into participantes(id_rol,id_relacion_usu_ar,id_proyecto) values (1,p_id_relacion,p_proyecto_id);
	EXCEPTION
        -- Si ocurre un error en la transacción principal, revertir
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE EXCEPTION 'Ha ocurrido un error en la transacción principal: %', SQLERRM;	
END;
$$;


select  dp.id_documento  from documentos_proyectos dp where dp.id_proyecto =35 and dp.estado ;

select * from documentos_proyectos dp where dp.id_proyecto =35 and dp.estado ;
--../../uploads/proyectos/Reglamente tutorias1692848695877.pdf
--../../uploads/proyectos/6 Direccionamiento IPv4-1692823699285-Cabezera.pdf
update documentos_proyectos set url_modificado ='../../uploads/proyectos/6 Direccionamiento IPv4-1692823699285-Cabezera.pdf' where id_documento = 204;
--204 
--../../
--./uploads/proyectos/Reglamente tutorias1692848695877.pdf
update documentos_proyectos set url_modificado = '../../uploads/proyectos/Reglamente tutorias1692848695877.pdf' where id_documento =204


--primer obtener el nombre del area y el nivel que esta aceptando segun el id del estado que esta editando jaajj saludos 
select n2.titulo  , ad.nombre_area 
from estado_nivel en
inner join niveles_proyecto np on en.id_nivel = np.id_niveles_pro  
inner join niveles n2  on np.id_nivel = n2.id_nivel 
inner join area_departamental ad on np.id_departamento = ad.id_area 
where en.id_estado =64;

select * from documentos_extras de where de.id_proyecto =35;
select * from documentos_proyectos dp where dp.id_proyecto =35;
update documentos_extras set estado = false where id_proyecto =35;

select * from niveles_proyecto np2 

select n.titulo , ad.nombre_area 
from niveles_proyecto np 
inner join niveles n on np.id_nivel = n.id_nivel 
inner join area_departamental ad on np.id_departamento =ad.id_area 
where id_niveles_pro = 65;
	
	
select * from historial_proyecto hp 






	select  en.id_estado 
	from proyectos p 
	inner join flujo_proyecto fp on p.id_proyecto =fp.id_proyecto 
	inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
	inner join estado_nivel en on np.id_niveles_pro = en.id_nivel  
	where p.id_proyecto =30
	order by en.id_estado desc limit 1;
	--editar ese id 
	update estado_nivel set observacion='Sin novedades', estado_nivel='Aceptado', enviando=true
      where id_estado = p_id_estado;
     --ahora tengo que escojer el nivel despues de este jajaja saludos
	select  np.id_niveles_pro  
	from proyectos p 
	inner join flujo_proyecto fp on p.id_proyecto =fp.id_proyecto 
	inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
	inner join estado_nivel en on np.id_niveles_pro = en.id_nivel  
	where p.id_proyecto =30
	order by en.id_estado desc limit 1;
	--ir al siguiente nivel 
	select into p_id_niveles_pro_insert np.id_niveles_pro  
	from proyectos p 
	inner join flujo_proyecto fp on p.id_proyecto =fp.id_proyecto 
	inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
	where p.id_proyecto =30 and np.id_niveles_pro >46
	order by np.id_niveles_pro  asc limit 1;
	--insertar este nuevo nivel como enviando xdxd saludos
     insert into estado_nivel(id_nivel,estado_nivel) values (p_id_niveles_pro_insert,'En revision');









select * from niveles_proyecto np where id_flujo =15;

select * from proyectos p where p.id_proyecto =24;


--proceso almacenado para aceptar un proyecto en publicacion
select * from proyectos p2 
inner join flujo_proyecto fp2 on p2.id_proyecto =fp2.id_proyecto 
inner join niveles_proyecto np2 on fp2.id_flujo = np2.id_flujo 
inner join niveles n on np2.id_nivel =n.id_nivel 
inner join estado_nivel en2 on np2.id_niveles_pro =en2.id_nivel 
where p2.id_proyecto =30
--escojer el ultimo estado del nivel para poder editarlo segun el id del proyecto
select en.id_estado , en.estado ,en.estado_nivel , en.enviando 
from proyectos p 
inner join flujo_proyecto fp on p.id_proyecto =fp.id_proyecto 
inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
inner join estado_nivel en on np.id_niveles_pro = en.id_nivel  
where p.id_proyecto =30 and en.enviando = false
order by en.id_estado desc limit 1;


--crear una tabla que coja el id del proyecto, el ultimo pdf que se subio a dicho proyecto, fecha de publicacion, y un estado
create table publicacion_proyecto(
	id_publicacion int generated always as identity,
	Url_doc varchar(900) not null unique,
	fecha_publicacion TIMESTAMPTZ default Now(),
	id_proyecto int not null,
	estado bool not null default true,
	primary key (id_publicacion)
);
select * from proyectos p ;

select * from publicacion_proyecto;
alter table publicacion_proyecto add constraint FK_ID_PROYECT foreign key (id_proyecto) references proyectos(id_proyecto);

--procedure para publicar proyecto 

select * from proyectos p2 where id_proyecto =30;


--hay que modificar esta funcion y la tabla publicaciones para saber que version del proyecto se esta publicando
select p.documento_preparado  from proyectos p ;


Create or Replace Procedure publicar_doc(
										p_proyecto_id int
										  )
Language 'plpgsql'
AS $$
declare
	p_id_estado int;
	p_url_doc varchar(900);
	p_titulo_proyecto varchar(900);
	p_version_p DECIMAL(5, 1);
	p_id_flujo int;
	p_id_area int;
	p_codigo_proyecto varchar(900);
begin
	--seleccionar el id a editar xdxdx Maholy aun no te olvido
	select into p_id_estado en.id_estado 
	from proyectos p 
	inner join flujo_proyecto fp on p.id_proyecto =fp.id_proyecto 
	inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
	inner join estado_nivel en on np.id_niveles_pro = en.id_nivel  
	where p.id_proyecto =p_proyecto_id and en.enviando = false
	order by en.id_estado desc limit 1;
	--editar ese id 
	update estado_nivel set observacion='Se publica el Documento', estado_nivel='Aceptado', enviando=true
      where id_estado = p_id_estado;
     --ahora se tiene que insertar el ultimo documento de ese proyecto en la tabla de publicaciones 
     --primero obtener la url del ultimo documento activo del proyecto mediante el id del proyect 
     select into p_url_doc url_modificado  from documentos_proyectos dp where id_proyecto = p_proyecto_id and estado =true order by id_documento  desc limit 1 ;
	--obtener los datos de la tabla proyecto Titulo, Version , ID flujo
    select p.titulo ,p.versionp into p_titulo_proyecto,p_version_p from proyectos p where p.id_proyecto =p_proyecto_id;
   --obtener el id del ultimo flujo que tiene un proyecto 
   select fp.id_flujo into p_id_flujo from flujo_proyecto fp where fp.id_proyecto = p_proyecto_id order by fp.id_flujo desc limit 1;
  --actualizar el proyecto a estado publicado jsjsjsjs skere modo diablo lol 
  	update proyectos set publicado = true, reforma=true ,documento_preparado=false where id_proyecto =p_proyecto_id;
  --obtener el id del area que elaboro el proyecto xdxd skere modo diablo
  select p.id_area_responsable,p.codigo  into p_id_area,p_codigo_proyecto from proyectos p where p.id_proyecto =p_proyecto_id;
    --ingresar los datos a la tabla jijijij ja
    insert into publicacion_proyecto(url_doc ,id_proyecto,versionp,id_flujo,titulo_publicacion,id_area,codigo) 
   	values (p_url_doc,p_proyecto_id,p_version_p,p_id_flujo,p_titulo_proyecto,p_id_area,p_codigo_proyecto);
	--ingresar los datos al historial de un proyecto ssjsjsj skere modo sjere 
   insert into historial_proyecto (detalle,boton,tipo,id_proyecto,Descripcion, titulo)
	values (concat('El proyecto: ',p_titulo_proyecto, ' se publicó'),false,10,p_proyecto_id,'Se publica el proyecto','Publicación');
	EXCEPTION
        -- Si ocurre un error en la transacción principal, revertir
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE EXCEPTION 'Ha ocurrido un error en la transacción principal: %', SQLERRM;	
END;
$$;

select * from historial_proyecto hp2 ;
select distinct tipo from historial_proyecto hp order by tipo asc ;

select fp.id_flujo  from flujo_proyecto fp where fp.id_proyecto = 35 order by fp.id_flujo desc limit 1;


select * from documentos_proyectos dp ;

select * from publicacion_proyecto;

select * from documentos_proyectos dp2 ;
select * from documentos_proyectos dp where id_proyecto = 30 and estado =true order by id_documento  desc limit 1 ;


--funcion que retorne la lista de los documentos publicados con id, titulo, fecha, categoria, area responsable.
select pp.id_publicacion, pp.url_doc,cast(TO_CHAR(pp.fecha_publicacion, 'DD-MON-YYYY') as varchar(500)) ,p.titulo ,p.codigo, cp.nombre_categoria , cp.prefijo_categoria ,
ad.nombre_area ,ad.prefijo_departamento 
from publicacion_proyecto pp
inner join proyectos p on pp.id_proyecto = p.id_proyecto 
inner join categorias_proyecto cp on p.id_categoria =cp.id_categoria 
inner join area_departamental ad on p.id_area_responsable =ad.id_area 
where pp.estado=true order by pp.fecha_publicacion asc;


select * from ver_proyectos_publicados();

create or replace function ver_proyectos_publicados()
returns table
(
	r_id_publicacion int, r_url_doc varchar(900), r_fecha_publicacion varchar(500), r_titulo_proyecto varchar(500), r_codigo_proyecto varchar(500),
	r_categoria varchar(500), r_prefijo_categoria varchar(500),r_nombre_area varchar(500),r_prefijo_area varchar(500)
)
language 'plpgsql'
as
$BODY$
begin
		return query
		select pp.id_publicacion, pp.url_doc,cast(TO_CHAR(pp.fecha_publicacion, 'DD-MON-YYYY') as varchar(500)) ,p.titulo ,p.codigo, cp.nombre_categoria , cp.prefijo_categoria ,
		ad.nombre_area ,ad.prefijo_departamento 
		from publicacion_proyecto pp
		inner join proyectos p on pp.id_proyecto = p.id_proyecto 
		inner join categorias_proyecto cp on p.id_categoria =cp.id_categoria 
		inner join area_departamental ad on p.id_area_responsable =ad.id_area 
		where pp.estado=true order by pp.fecha_publicacion asc;
		end;
$BODY$



---INicio de sesion con google 

----------Funcion para validar que existe el correo que manda con google--------------
-- DROP FUNCTION IF EXISTS public.verification_auth_google(character varying);

CREATE OR REPLACE FUNCTION public.verification_auth_google(
	email character varying)
    RETURNS TABLE(verification integer, mensaje character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

declare
	User_Deshabili bool;
	User_Exit bool;
begin
	--Primero Verificar si el correo que se esta ingresando existe
	select into User_Exit case when COUNT(*)>=1 then True else false end  from usuario where correo_institucional=email;	
	--Segundo  Verificar si el usuario tiene un estado habilitado o deshabilitado
	if (User_Exit) then 
		select into User_Deshabili estado from usuario where correo_institucional=email;
		if (User_Deshabili) then 
			return query
			select
			cast(case when COUNT(*)>=1 then 1 else 2 end as int),
			 cast(case when COUNT(*)>=1 then 'Login Correcto' else 'Contraseña incorrecta' end as varchar(500))
			from usuario
			where correo_institucional  = email
			and estado=true;
   		else 
   			return query
			select cast(3 as int), cast('Usuario deshabilitado contacte con un administrador' as varchar(500));
		end if;
	else 
	   		return query
			select cast(4 as int), cast('Este correo no esta registrado' as varchar(500));
	end if;
end;
$BODY$;



--select * from usuario

--select case when COUNT(*)>=1 then True else false end  from usuario where correo_institucional='john@uteq.edu.ec'

--select estado from usuario where correo_institucional='john@uteq.edu.ec';

/*select
			cast(case when COUNT(*)>=1 then 1 else 2 end as int),
			 cast(case when COUNT(*)>=1 then 'Login Correcto' else 'Contraseña incorrecta' end as varchar(500))
			from usuario
			where correo_institucional  = 'john@uteq.edu.ec'
			and estado=true;
*/

------------Funcion para sacar el id de usario------------------
-- DROP FUNCTION IF EXISTS public.auth_data_google(character varying);

CREATE OR REPLACE FUNCTION public.auth_data_google(
	email character varying)
    RETURNS TABLE(userd character varying, verification boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

begin
	return query
	select cast(ID_User as varchar(500)) as UserT,IsAdmin as AdminS  from usuario where correo_institucional  = email;
end;
$BODY$;





--select cast(ID_User as varchar(500)) as UserT,IsAdmin as AdminS  from usuario where correo_institucional  = 'john@uteq.edu.ec'


select * from documentos_proyectos dp ;


documento_proyecto

--crear una consulta que me envie los datos de un proyecto para poner en el encabezado segun el id del proyecto;
--Sistema de Gestion de la calidad de la UTEQ
--Direccion Academica -> Area
--Titulo del proyectos 
--Codigo del proyectos 
--Version del proyecto --aun no esta definido
--Responsable --> Area
--Fecha de creacion --> Junio 2020 x ejemplo
--Numero de Pagina

--consulta 
select 
ad.nombre_area ,p.titulo ,p.codigo ,  cast(TO_CHAR(p.fecha_creacion, 'MON-YYYY') as varchar(500))
from proyectos p 
inner join area_departamental ad on p.id_area_responsable =ad.id_area 
where p.id_proyecto =24;

--funcion para retornar la data : 

DROP FUNCTION pro_encabezado(integer);



DROP FUNCTION pro_encabezado(integer) ;
create or replace function pro_encabezado(idu int)
returns table
(
	r_area_responsable varchar(800), r_titulo varchar(800), r_codigo varchar(800), r_fecha varchar(800),r_version varchar(800), r_url_foto_empresa varchar(800)
)
language 'plpgsql'
as
$BODY$
begin
	return query
	
	select * from (
	select 
	ad.nombre_area ,p.titulo ,p.codigo ,  cast(TO_CHAR(p.fecha_creacion, 'MON-YYYY') as varchar(500)), cast(TO_CHAR(p.versionp, 'FM999D0')as varchar(500))
	from proyectos p 
	inner join area_departamental ad on p.id_area_responsable =ad.id_area 
	where p.id_proyecto =idu) as X inner join 
	(select e.url_logo from empresa e) as Y
	on 1=1
	;
end;
$BODY$


select * from pro_encabezado(24);



--modificar la funcion que retorna los datos del encabezado para andirle la url de la imagen de la empresa 
select * from (
	select 
	ad.nombre_area ,p.titulo ,p.codigo ,  cast(TO_CHAR(p.fecha_creacion, 'MON-YYYY') as varchar(500))
	from proyectos p 
	inner join area_departamental ad on p.id_area_responsable =ad.id_area 
	where p.id_proyecto =24) as X inner join 
	(select e.url_logo from empresa e) as Y
	on 1=1
	;


select * from empresa e;


select * from flujo_proyecto fp inner join proyectos p on fp.id_proyecto =p.id_proyecto  where p.titulo ='Pruebas nuevas';
select * from niveles_proyecto np where id_flujo =20;
select * from estado_nivel en where id_nivel = 51;

update estado_nivel set estado =false where id_estado = 19
update niveles_proyecto set estado = false where id_flujo =20;
update flujo_proyecto set estado = false where id_flujo = 20; 




--funcion para deshabilitar el flujo de un proyecto segun el id del proyecto 
select * from proyectos p where p.id_proyecto =32;
--este id del flujo tiene que pasar a false
select * from flujo_proyecto fp where fp.id_proyecto = 32 and fp.estado =true;
--21
--estos niveles se tienen que pasar a false 
select * from niveles_proyecto np where np.id_flujo =21 and np.estado = true ;
select * from estado_nivel where id_nivel =52
select * from estado_nivel where id_nivel =53
select * from estado_nivel where id_nivel =54


select * from niveles_proyecto np 
inner join estado_nivel en on np.id_niveles_pro = en.id_nivel 
where np .id_flujo =21 and np.estado = true ;


--editar todos los registros de una tabla mediante inner join
update estado_nivel 
set estado = true 
from niveles_proyecto  where estado_nivel.id_nivel  = niveles_proyecto.id_niveles_pro 
						and niveles_proyecto.id_flujo = 21 and niveles_proyecto.estado = true


call cambiar_estado_flujo(32);
--funcion para deshabilitar todo el flujo de un proyecto
Create or Replace Procedure cambiar_estado_flujo(
										   p_id_proyecto int 
										 )
Language 'plpgsql'
AS $$
declare 
	P_id_flujo int; 
	p_ultimo_historial int;
	es_reforma bool;
	peso DECIMAL(5, 1);
	Prefijo_proyect varchar(50);
	Prefijo_area varchar(50);
	Prefijo_categoria varchar(50);
	p_id_tipo int;
Begin	
	--primero se necesita obtener el id del flujo dependiendo del proyecto  
	select fp.id_flujo,fp.id_tipo_jerarquia  into P_id_flujo,p_id_tipo  from flujo_proyecto fp where fp.id_proyecto = p_id_proyecto and fp.estado =true;
	--segundo hay que hacer update de los estados de los niveles segun el id del flujo obtenido mediante el inner join
	update estado_nivel 
	set estado = false 
	from niveles_proyecto  where estado_nivel.id_nivel  = niveles_proyecto.id_niveles_pro 
						and niveles_proyecto.id_flujo = P_id_flujo and niveles_proyecto.estado = true;
	--hacer update a los niveles y cambiarlos a false
	update niveles_proyecto set estado =false where id_flujo = P_id_flujo;				
	--hacer update a ese id_flujo y cambiarlo a false 
	update flujo_proyecto set estado =false where id_flujo =P_id_flujo;
	--insertar ese flujo en historial del proyecto 
	
	
	insert into historial_proyecto (detalle,boton,tipo,id_proyecto,Descripcion, titulo)
	values (concat('Se ha eliminado el flujo actual del proyecto'),true,7,p_id_proyecto,'Flujo del proyecto Eliminado','Eliminar flujo');
	--ahora obtener el id de la ultima historia proyecto para conectar ese historial con el flujo 
	--p_ultimo_historial
	select id_historial into  p_ultimo_historial from historial_proyecto hp where hp.id_proyecto =p_id_proyecto  order by id_historial desc limit 1;
	--ahora insertar eso en la tabla flujo_historial para empatar el flujo rechazado con el id de la historia 
	insert into historial_flujo(id_flujo,id_historial) values (P_id_flujo,p_ultimo_historial );

	--aqui obtener si el proyecto es reforma para ver si se actualiza la version y el codigo del proyecto?
	select p.reforma into es_reforma from proyectos p where p.id_proyecto =p_id_proyecto;
	--aqui hacer la condicion if para sumar la version del proyecto ssjsj skere modo pija
			if(es_reforma)then
				--obtener el tipo del flujo segun el id del flujo
				--obtener el peso del flujo para restarlo con la version actual del proyecto
				select tj.valor into peso from tipos_jerarquia tj where tj.id_tipo =p_id_tipo;
				--obtener todo los demas datos como el prefijo del proyecto, prefijo de area, prefijo extc sxs y la version actual del proyecto
				--concat(Prefijo_proyect,'-', Prefijo_area,'-',Prefijo_categoria,'-',Version_actual)
				select p.prefijo_proyecto , ad.prefijo_departamento , cp.prefijo_categoria into Prefijo_proyect,Prefijo_area,Prefijo_categoria
				from proyectos p
				inner join area_departamental ad on p.id_area_responsable =ad.id_area
				inner join categorias_proyecto cp on p.id_categoria =cp.id_categoria where p.id_proyecto =p_id_proyecto ;
				--ahora hacer el update a la version del proyecto y al codigo del proyecto 
				update proyectos set versionp =versionp-peso, codigo =concat(Prefijo_proyect,'-', Prefijo_area,'-',Prefijo_categoria,'-',versionp-peso) where id_proyecto =p_id_proyecto;
			end if;
	
EXCEPTION
        -- Si ocurre un error en la transacción principal, revertir
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE EXCEPTION 'Ha ocurrido un error: %', SQLERRM;
END;
$$;

select * from historial_proyecto hp ;
--consulta para saber si un proyecto fue enviado a un nivel superior 
select * from proyectos p ;
--prueba con el id = 24 
--si tiene 2 o mas niveles estados, quiere decir que se envio a un nivel de revision superior y por ende no debe dejar editar nada del proyecto
--ni subir nuevos documentos
select case when Count(*) >= 2 then true else false end as Indicador 
from flujo_proyecto fp 
inner join niveles_proyecto np on fp.id_flujo = np.id_flujo 
inner join estado_nivel en on np.id_niveles_pro =en.id_nivel 
where fp.id_proyecto =30 and fp.estado = true;
  --niveles_estado_proyecto


select *
from flujo_proyecto fp 
inner join niveles_proyecto np on fp.id_flujo = np.id_flujo 
inner join estado_nivel en on np.id_niveles_pro =en.id_nivel 
where fp.id_proyecto =30 and fp.estado = true;


--funcion para rechazar en un nivel un proyecto 
select * from proyectos p ;
--id del proyecto = 30 nombre = Niveles Proyecto 
--primero obtener el id del flujo actual del proyecto en estado true
select * from flujo_proyecto fp where fp.id_proyecto =30 and fp.estado;
--id del flujo 26 
--obtener los niveles de ese flujo del proyecto en estado true 
select * from niveles_proyecto np where np.id_flujo =26 and np.estado;
--67
--68
--69
--en lugar de obtener los id de los estados niveles se los puede mandar a editar mediante el id del nivel encontrado anterioremente 
--obtener los estados niveles de dichos niveles en true siempre y cuando existan dependiendo del nivel 
select * from estado_nivel en where en.id_nivel =67 and en.estado ;
select * from estado_nivel en where en.id_nivel =68 and en.estado ;
select * from estado_nivel en where en.id_nivel =69 and en.estado ;
--en lugar de obtener los id de los estados niveles se los puede mandar a editar mediante el id del nivel encontrado anterioremente 
--crear un nuevo flujo con el id de proyecto = 30 
--crear nuevos niveles del flujo segun lo encontrado anteriormente aqui creo que tengo que crear un cursor 
--crear el primer estado nivel que seria el de elaboracion 
--editar los estados del nivel del flujo segun el id de los niveles encontrados a false 
--editar los niveles del flujo segun el id del flujo a false 
--editar el flujo encontrado a false 
--insertar en la tabla historial este rechazo y unir con una tabla el flujo que anteriormente se le cambio el estado 

	select fp.id_tipo_jerarquia  from flujo_proyecto fp where fp.id_proyecto = 30 and fp.estado =true;
 select fp2.id_flujo  from flujo_proyecto fp2 where fp2.id_proyecto =30 and estado = true ;
--creacion del procedure para rechazar un proyecto en cualquier nivel




	select * from flujo_proyecto fp2 where id_proyecto = 30;
	select * from niveles_proyecto np where id_flujo =36;
	
	select * from niveles_proyecto np where id_flujo =26;
	select * from estado_nivel en where en.id_nivel =82

	--eliminar los registros no validos 
	id nivel dep id flujo
		58	30
		60	30
		63	30
		58	29
		60	29
		63	29
	
	delete from niveles_proyecto where id_niveles_pro = 1297406
	delete from flujo_proyecto where id_flujo = 31
	
	
call  rechazar_proyecto(30);
	--resetear los id del nivel 
	select * from niveles_proyecto np order by np.id_niveles_pro asc;

	SELECT setval(pg_get_serial_sequence('niveles_proyecto', 'id_niveles_pro'), 70, 1);

	SELECT SETVAL('niveles_proyecto_id_niveles_pro_seq', (SELECT MAX(id_niveles_pro) FROM niveles_proyecto));
	SELECT setval('niveles_proyecto_id_niveles_pro_seq', (SELECT MAX(id_niveles_pro) FROM niveles_proyecto));

	
	select fp.id_flujo  from flujo_proyecto fp where fp.id_proyecto = 30 and fp.estado =true;
	select fp.id_tipo_jerarquia  from flujo_proyecto fp where fp.id_flujo  = 26;


select * from historial_proyecto hp ;
update historial_proyecto set descripcion='por pruebas' where id_historial = 1;
call  rechazar_proyecto(30,'Por pruebas');

Create or Replace Procedure rechazar_proyecto(
										   p_id_proyecto int ,
										   p_descripcion varchar(500)
										 )
Language 'plpgsql'
AS $$
declare 
	P_id_flujo int;
	p_id_tipo int;
	p_id_nivel_flujo int;
	p_primer_nivel int;
	p_id_niveles_pro int;
	p_nombre_area varchar(500); 
	p_titulo varchar(500); 
	p_estado_nivel  varchar(500); 
	p_ultimo_historial int;
	p_id_area_elaboracion int;
Begin	
	--obtener el id del flujo actual mediante el el id del proyecto 
	select fp.id_flujo INTO P_id_flujo  from flujo_proyecto fp where fp.id_proyecto = p_id_proyecto and fp.estado =true;
	--obtener el id del tipo jerarquia mediantw el id del proyecto 
	select fp.id_tipo_jerarquia INTO p_id_tipo  from flujo_proyecto fp where fp.id_flujo  = P_id_flujo;
	--cambiar el estado del flujo obtenido a false 
	update flujo_proyecto set estado =false where id_flujo  = P_id_flujo;
 	--aqui va la parte del cursor 
 	PERFORM copiar_niveles(P_id_flujo,p_id_proyecto,p_id_tipo);
 	--aqui termina la parte del cursor 
 	--hacer update de los estados de los niveles segun el id del flujo obtenido mediante el inner join
	update estado_nivel 
	set estado = false 
	from niveles_proyecto  where estado_nivel.id_nivel  = niveles_proyecto.id_niveles_pro 
						and niveles_proyecto.id_flujo = P_id_flujo;
	--hacer update a los niveles y cambiarlos a false
	update niveles_proyecto set estado =false where id_flujo = P_id_flujo;
	--insertar un estado nivel para elaboracion 
	--parece que esto ya lo hace automatico xd 
	--me equivoque no lo hace automatico xd 
--ahora se necesita registrar el estado del nivel que seria el primero: elaboracion -> 'En elaboracion'
   --para ello primero se toma el ultimo flujo creado del proyecto
   	select into p_id_nivel_flujo id_flujo  
	from flujo_proyecto fp
	where fp.id_proyecto =p_id_proyecto and fp.estado =true order by id_flujo asc limit 1;
	--ahora se toma el primer nivel de ese flujo para insertarlo en el estado nivel 
	select into p_primer_nivel id_niveles_pro  from niveles_proyecto np where np.id_flujo = p_id_nivel_flujo and estado =true order by nivel asc limit 1;
	--y se inserta ese p_primer_nivel en los estados del nivel con la observacion -> "EN elaboracion"
	insert into  estado_nivel (id_nivel,observacion,estado_nivel) values (p_primer_nivel, 'Se empieza la elaboracion','Sin enviar');
	--ahora falta anadir el flujo rechazado al historial xd modo skere zetzo
	--obtener el area que rechaza el proyecto seria conectando el ultimo estado nivel
	--tambien hay que obtener el ultimo estado nivel para actualizarlo y en estado ponerle rechazado
	--todos estas columnas se deben guardar en variables indepentienes para concatenar el texto xdxdxdxds y para editar ese id en estado nivel
	--el ultimo nivel de un proyecto cuando se rechaza 
	select np.id_niveles_pro , ad.nombre_area, n.titulo, en.estado_nivel
	into p_id_niveles_pro, p_nombre_area, p_titulo , p_estado_nivel
	from niveles_proyecto np  
	inner join area_departamental ad on np.id_departamento =ad.id_area 
	inner join niveles n on np.id_nivel = n.id_nivel
	inner join estado_nivel en on np.id_niveles_pro =en.id_nivel 
	where np.id_flujo= P_id_flujo order by np.nivel  desc limit 1;
	--actualizar el estado del ultimo nivel a rechazao de pana j0der Maholy aun no te olvido xd setzo modo skere
	update estado_nivel  set estado_nivel  ='Rechazado' where id_nivel  = p_id_niveles_pro;
	--ahora insertar en la tabla historial el texto xdxdxdxd
	--	new.codigo = concat(new.prefijo_proyecto,'-', Pref_area,'-',Pref_cat,'-',new.id_proyecto);
	--	insert into  estado_nivel (id_nivel,observacion,estado_nivel) values (p_primer_nivel, 'Se empieza la elaboracion','Sin enviar');
	insert into historial_proyecto (detalle,boton,tipo,id_proyecto,Descripcion, titulo)
	values (concat('El area: ',p_nombre_area, ' rechazó el proyecto en el nivel de: ',p_titulo),true,0,p_id_proyecto,p_descripcion,'Rechazo del proyecto');
	--ahora obtener el id de la ultima historia proyecto para conectar ese historial con el flujo 
	--p_ultimo_historial
	select id_historial into  p_ultimo_historial from historial_proyecto hp where hp.id_proyecto =p_id_proyecto order by id_historial desc limit 1;
	--ahora insertar eso en la tabla flujo_historial para empatar el flujo rechazado con el id de la historia 
	insert into historial_flujo(id_flujo,id_historial) values (P_id_flujo,p_ultimo_historial );
	--actualizar los estados de los documentos extras sjjajja skere modo Maholy
	update documentos_extras set estado = false where id_proyecto =p_id_proyecto;
	--aqui tengo que actualizar todos los participantes QUE NO TENGAN EL ID DEL AREA DE ELABORACION a fase 
	--primero obtener el id del area de elaboracion 
	select np.id_departamento into p_id_area_elaboracion 
	from proyectos p
	inner join flujo_proyecto fp on p.id_proyecto = fp.id_proyecto  
	inner join niveles_proyecto np on fp.id_flujo = np.id_flujo 
	where p.id_proyecto =p_id_proyecto and fp.estado and np.nivel=0;
	--con ese id actualizar la lista de participantes a false siempre y cuando no sea iguales al id del area de elaboracion

	update participantes set estado = false 
	from usuarios_areas 
	where participantes.id_relacion_usu_ar = usuarios_areas.id_relacion and participantes.id_proyecto = p_id_proyecto and 
	usuarios_areas.id_area <> p_id_area_elaboracion;
	
	update proyectos set documento_preparado =false where id_proyecto =p_id_proyecto;

EXCEPTION
        -- Si ocurre un error en la transacción principal, revertir
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE EXCEPTION 'Ha ocurrido un error: %', SQLERRM;
END;
$$;

--58
select ua.id_area 
from participantes p 
inner join usuarios_areas ua ON p.id_relacion_usu_ar =ua.id_relacion 
where p.id_proyecto =35 and p.estado and ua.id_area <> 58;


select u.nombres , ad.nombre_area , n.titulo , p2.titulo , ad.id_area 
from participantes p 
inner join proyectos p2 on p2.id_proyecto =p.id_proyecto 
inner join flujo_proyecto fp on p2.id_proyecto = fp.id_proyecto 
inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
inner join usuarios_areas ua on p.id_relacion_usu_ar = ua.id_relacion 
inner join niveles n on np.id_nivel =n.id_nivel 
inner join usuario u on ua.id_usuario =u.id_user 
inner join area_departamental ad on ua.id_area = ad.id_area 
where p.id_proyecto =35 and fp.estado and np.id_departamento =ua.id_area and p.estado;

--desde aqui obtengo el id del area de elaboracion, entonces tengo que actualizar la lista de participantes que no tenga este id de area
--mediante un update inner join where not id 
select np.id_departamento  
from proyectos p
inner join flujo_proyecto fp on p.id_proyecto = fp.id_proyecto  
inner join niveles_proyecto np on fp.id_flujo = np.id_flujo 
where p.id_proyecto =35 and fp.estado and np.nivel=0;


--ver los participantes actuales que tiene un proyecto sin importar su nivel 


--funcion para el cursor 
CREATE OR REPLACE FUNCTION copiar_niveles(P_id_flujo int, p_id_proyecto int, p_id_tipo int)
RETURNS VOID AS
$$
DECLARE
 	ID_nivel_c int;
 	ID_Departamente int;
 	ID_nivel int;
 	Nivel int;
 	P_id_flujo_new int;
    curCopiar cursor for select id_niveles_pro  from niveles_proyecto np where np.id_flujo =P_id_flujo and np.estado;
begin
	--crear un nuevo flujo segun el id del proyecto 
	insert into flujo_proyecto (id_proyecto ,id_tipo_jerarquia)values
	(p_id_proyecto,p_id_tipo);
	--obtener el id flujo ultimo creado 
 	select fp2.id_flujo  INTO P_id_flujo_new  from flujo_proyecto fp2 where fp2.id_proyecto  =p_id_proyecto and estado = true ;
	
   open curCopiar;
	fetch next from curCopiar into ID_nivel_c;
	while (Found) loop	
	 select np.id_departamento, np.id_nivel ,np.nivel into ID_Departamente,ID_nivel,Nivel from niveles_proyecto np where np.id_niveles_pro=ID_nivel_c;
		--esto tiene que insertar el cursor en la tabla
		insert into niveles_proyecto(id_departamento,id_flujo,id_nivel,nivel)
		values(ID_Departamente,P_id_flujo_new,ID_nivel,Nivel);
		--cerrar el cursor 
	fetch curCopiar into ID_nivel_c;
	end loop;
	close curCopiar;
	EXCEPTION
        -- Si ocurre un error en la transacción principal, revertir
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE EXCEPTION 'Ha ocurrido un error: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;

select * from historial_flujo hf ;
select id_historial  from historial_proyecto hp order by id_historial desc limit 1;

select * from flujo_proyecto fp where fp.id_proyecto = 30 and fp.estado ;
select np.id_niveles_pro , ad.nombre_area, n.titulo, en.estado_nivel
	from niveles_proyecto np  
	inner join area_departamental ad on np.id_departamento =ad.id_area 
	inner join niveles n on np.id_nivel = n.id_nivel
	inner join estado_nivel en on np.id_niveles_pro =en.id_nivel 
	where np.id_flujo= 36 order by np.nivel  desc limit 1;
--crear una tabla para el historial del proyecto:
--es decir, aqui va ir cuando se inicia el proyecto con Titulo = 'Inicia el proyecto', fecha de creacion, id 
--tambien va a ir cuando se anada un participante, o cuando se suba de nivel el proyecto, cuando se rechaze y cuando se publique xd
--tipo = ejemplo usuario - flujo - etc 
--boton bool 
--el boton se usuara por ejemplo si es rechazo de un nivel para poder ver hasta donde llego y en donde se rechazo, o si se anadio un usuario para ver su perfil

create table historial_proyecto(
	id_historial INT GENERATED ALWAYS AS IDENTITY,
	titulo varchar(200) not null ,
	fecha_creacion TIMESTAMPTZ DEFAULT Now(),
	estado bool not null default true,
	boton bool not null default true,
	tipo int not null,
	id_proyecto  int not null,
		Primary Key(id_historial)
);

select * from proyectos p ;
alter table historial_proyecto add constraint FK_id_proyecto foreign key (id_proyecto) references proyectos(id_proyecto);

--ahora crear una tabla que empate la tabla historia_proyecto con el flujo del proyecto
--para cuando se suba el nivel o se rechaze aparesca en el historial del proyecto


create table historial_flujo(
	id_historial_flujo INT GENERATED ALWAYS AS IDENTITY,
	id_flujo int not null ,
	id_historial  int not null,
	fecha_creacion TIMESTAMPTZ DEFAULT Now(),
	estado bool not null default true,
	Primary Key(id_historial_flujo)
);
select * from flujo_proyecto fp ;
alter table historial_flujo add constraint FK_ID_Historial foreign key (id_historial) references historial_proyecto(id_historial);
alter table historial_flujo add constraint FK_ID_Flujo foreign key (id_flujo) references flujo_proyecto(id_flujo);



--anadir una columna de descripcion para el historial del proyecto para saber xq se rechazo xdxd skere modo diablo 
alter table historial_proyecto  
add column Descripcion varchar(200);
--anadir una columna detalle 
alter table historial_proyecto  
add column Detalle varchar(200);

--cambiar el detalle por el titulo 
-- el titulo solo debe contener pocos caracteres xd 
select * from historial_proyecto hp ;
update historial_proyecto set titulo='Rechazo del proyecto' where id_historial =2;
update historial_proyecto set titulo='Rechazo del proyecto' where id_historial =1;
update historial_proyecto set titulo='Rechazo del proyecto' where id_historial =3;


select id_historial ,titulo, descripcion, detalle from historial_proyecto hp ;


--funcion para ver el historial de un proyecto 
select * from historial_proyecto hp where hp.id_proyecto =30;




select * from ver_historial_proyecto(30);

DROP FUNCTION ver_historial_proyecto(integer);
create or replace function ver_historial_proyecto(p_id_proyecto int)
returns table
(
	r_id_historial int, r_titulo  varchar(800), r_fecha  varchar(800), r_estado bool, r_boton bool, r_tipo  int, r_descripcion  varchar(800),  r_detalle  varchar(800)
)
language 'plpgsql'
as
$BODY$
begin
	return query
select hp.id_historial ,hp.titulo,
	cast( EXTRACT(MONTH FROM hp.fecha_creacion) || '/' || EXTRACT(DAY FROM hp.fecha_creacion) || '/' || EXTRACT(YEAR FROM hp.fecha_creacion)
	 as varchar(500)), hp.estado ,hp.boton ,hp.tipo ,hp.descripcion , hp.detalle
	from historial_proyecto hp where hp.id_proyecto =p_id_proyecto  and hp.estado order by hp.fecha_creacion asc;
end;
$BODY$


	select hp.id_historial ,hp.titulo,
	cast( EXTRACT(MONTH FROM hp.fecha_creacion) || '/' || EXTRACT(DAY FROM hp.fecha_creacion) || '/' || EXTRACT(YEAR FROM hp.fecha_creacion)
	 as varchar(500)), hp.estado ,hp.boton ,hp.tipo ,hp.descripcion 
	from historial_proyecto hp where hp.id_proyecto =30;

--cast(TO_CHAR(dp.fecha_creacion, 'DD-MON-YYYY') as varchar(500))




--funcion para ver los niveles que tuvo ese proyecto cuando se rechazo segun el id del flujo
select 
	en.id_estado ,en.estado ,cast(TO_CHAR(en.fecha, 'DD-MON-YYYY') as varchar(500)),en.observacion ,en.id_nivel ,en.estado_nivel,ad.id_area ,ad.nombre_area ,np.nivel, cast(true as bool) ,  n.titulo 
	from 
	flujo_proyecto fp
	inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
	inner join estado_nivel en on np.id_niveles_pro =en.id_nivel 
	inner join area_departamental ad on np.id_departamento =ad.id_area 
	inner join niveles n on np.id_nivel =n.id_nivel 
	where fp.id_flujo  =40  order by np.nivel asc;


select * from ver_flujo_rechazado(4);

create or replace function ver_flujo_rechazado(p_id_historial int)
returns table
(
r_id_estado int, r_estado bool, r_fecha_estado varchar(500), r_observacion varchar(200),
	r_id_nivel int, r_estado_nivel varchar(200), r_id_area int, r_nombre_area varchar(200), r_nivel int, click bool,
	r_tipo_nivel varchar(500)
)
language 'plpgsql'
as
$BODY$
declare
	p_id_flujo_historial int;
begin
	--primero necesito obtener el di del flujo segun el id del historial_flujo 
	select hf.id_flujo  into p_id_flujo_historial from historial_flujo hf where hf.id_historial  =p_id_historial;
	--con ese id del flujo puedo hacer la consulta para dibujar el mapa de las rutas
	return query
	select 
	en.id_estado ,en.estado ,cast(TO_CHAR(en.fecha, 'DD-MON-YYYY') as varchar(500)),en.observacion ,en.id_nivel ,en.estado_nivel,ad.id_area ,ad.nombre_area ,np.nivel, cast(true as bool) ,  n.titulo 
	from 
	flujo_proyecto fp
	inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
	inner join estado_nivel en on np.id_niveles_pro =en.id_nivel 
	inner join area_departamental ad on np.id_departamento =ad.id_area 
	inner join niveles n on np.id_nivel =n.id_nivel 
	where fp.id_flujo  =p_id_flujo_historial  order by np.nivel asc;
end;
$BODY$


select * from historial_flujo hf ;
select * from historial_proyecto hp ;
select ad.id_area ,ad.nombre_area ,n.titulo ,np.nivel 
	from niveles_proyecto np
	inner join area_departamental ad on np.id_departamento =ad.id_area 
	inner join niveles n ON np.id_nivel =n.id_nivel 
	where np.id_flujo =44
	order by np.nivel asc;


--ver el flujo que se creo en el proyecto segun el id del flujo del historial
select * from historial_proyecto hp ;
select * from flujo_Historial(8);
create or replace function flujo_Historial(p_id_historial int)
returns table
(
	Area_id int,NombreArea varchar(200),Nivel varchar(500), Numero int
)
language 'plpgsql'
as
$BODY$
declare
	p_id_flujo_historial int;
begin
	--obtener el id del flujo
	select hf.id_flujo  into p_id_flujo_historial from historial_flujo hf where hf.id_historial  =p_id_historial;
	return query
	--aqui retornar la tabla
	select ad.id_area ,ad.nombre_area ,n.titulo ,np.nivel 
	from niveles_proyecto np
	inner join area_departamental ad on np.id_departamento =ad.id_area 
	inner join niveles n ON np.id_nivel =n.id_nivel 
	where np.id_flujo =p_id_flujo_historial
	order by np.nivel asc;
end;
$BODY$


select tipo, titulo , id_historial  from historial_proyecto hp ;
update historial_proyecto set tipo = 6 where id_historial = 11;
update historial_proyecto set tipo = 6 where id_historial = 18;

--anadir un nuevo campo a documento proyecto para poder subir un documento modificar y el otro dejarlo intacto xd 

select url_doc , url_modificado, id_documento  from documentos_proyectos dp where id_proyecto =33;
update documentos_proyectos set url_modificado=url_doc 

--crear la tabla documentos extras xd 
create table documentos_extras(
	ID_documento_extra int generated always as identity,
	URl_Doc varchar(500)not null,
	Estado bool default true not null,
	ID_Proyecto int,
	Descripcion varchar(500)not null,
	Id_nivel int not null,
	Fecha_creacion TIMESTAMPTZ DEFAULT Now(),
		primary key(ID_documento_extra)
);

--conectar la tabla documentos extras con el el proyecto y con el nivel del flujo
select * from proyectos p ;
--primero conectar con la tabla proyectos: 
alter table documentos_extras add constraint FK_Id_proyecto_extra foreign key (ID_Proyecto) references proyectos(id_proyecto);
--ahora conectar con la tabla niveles 
select * from niveles_proyecto np ;
alter table documentos_extras add constraint FK_ID_nivel_extra foreign key (Id_nivel) references niveles_proyecto(id_niveles_pro);

---procedimiento almacenado para anadir un documento extra al proyectos segun el nivel que se encuentra actualmente ajaj eskere modo diablo
--primero necesito el id del nivel actual segun el estado del nivel del proyecto 
select * from proyectos p where id_proyecto =35;
--id del proyecto = 35
--aqui obtengo el id del nivel del proyecto xdxdx skere modo diablo 
select np.id_niveles_pro  
from flujo_proyecto fp 
inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
inner join estado_nivel en on np.id_niveles_pro = en.id_nivel 
inner join niveles n on np.id_nivel =n.id_nivel 
where fp.id_proyecto =35 and fp.estado order by en.id_estado desc limit 1;
--ahora si crear el procedimeinto almacenado para insertar la URL del documeto extra segun el id del proyecto 
select * from documentos_extras de ;

--probar el procedimieto almacenado para los docuemnto extras
--aqui esta insertado  
call insertar_documentos_extras('../../uploads/proyectos/ilovepdf_merged-1691387847266.pdf','35','segundo extra');
select * from documentos_proyectos dp ;
select * from documentos_extras de;

select np.id_niveles_pro 
		from flujo_proyecto fp 
		inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
		inner join estado_nivel en on np.id_niveles_pro = en.id_nivel 
		inner join niveles n on np.id_nivel =n.id_nivel 
		where fp.id_proyecto =cast(35 as int) and fp.estado order by en.id_estado desc limit 1;


select * from documentos_extras de ;
update documentos_extras set descripcion='Skere' where id_documento_extra =42;
Create or Replace Procedure insertar_documentos_extras(p_url varchar(200),
										   p_id_proyecto varchar(200),
										   p_descripcion varchar(100)
										   )
Language 'plpgsql'
AS $$
declare 
	p_id_nivel int;
begin
		--obtener el id del nivel para insertar el registo en la tabla
	if trim(p_descripcion)='' then
			raise exception 'Descripcion no puede ser vacio';
	end if;
	if trim(p_url)='' then
			raise exception 'Url del documento no puede ser vacio';
	end if;
		select into p_id_nivel np.id_niveles_pro
		from flujo_proyecto fp 
		inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
		inner join estado_nivel en on np.id_niveles_pro = en.id_nivel 
		inner join niveles n on np.id_nivel =n.id_nivel 
		where fp.id_proyecto =cast(p_id_proyecto as int) and fp.estado order by en.id_estado desc limit 1;
		--aqui registrar 
		insert into documentos_extras(url_doc, id_proyecto,descripcion,id_nivel,tipo_carta)
		values(p_url,cast(p_id_proyecto as int),p_descripcion,p_id_nivel,true);
	EXCEPTION
        -- Si ocurre un error en la transacción principal, revertir
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE EXCEPTION 'Ha ocurrido un error en la transacción principal: %', SQLERRM;
END;
$$;

--hacer una funcion que retorne los documentos del ultimo nivel apra poder verlos xd 

select * from Ver_documentos_extras(35);

select * from documentos_extras de ;
--../../uploads/proyectos/Direccionamiento IPv4-1692716622879-Cabezera.pdf
select * from documentos_proyectos dp ;
update documentos_extras set url_doc = '../../uploads/proyectos/Direccionamiento IPv4-1692716622879-Cabezera.pdf'


DROP FUNCTION ver_documentos_extras(integer);
create or replace function Ver_documentos_extras(p_id_proyecto int)
returns table
(
	r_id_documento_extra int, r_url_doc varchar(800), r_estado bool, r_descripcion varchar(800), r_id_nivel int, r_fecha_creacion varchar(800)
)
language 'plpgsql'
as
$BODY$
declare 
	p_id_nivel int;
begin
	--obtener el id del nivel para insertar el registo en la tabla
		select np.id_niveles_pro  into p_id_nivel
		from flujo_proyecto fp 
		inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
		inner join estado_nivel en on np.id_niveles_pro = en.id_nivel 
		inner join niveles n on np.id_nivel =n.id_nivel 
		where fp.id_proyecto =p_id_proyecto and fp.estado order by en.id_estado desc limit 1;
	return query
	select 
	de.id_documento_extra , de.url_doc , de.estado  , de.descripcion , de.id_nivel,
		cast( EXTRACT(MONTH FROM de.fecha_creacion) || '/' || EXTRACT(DAY FROM de.fecha_creacion) || '/' || EXTRACT(YEAR FROM de.fecha_creacion)
	 as varchar(500))
	from documentos_extras de where de.id_proyecto =p_id_proyecto and de.estado and de.id_nivel =p_id_nivel and de.tipo_carta;
end;
$BODY$

select * from documentos_extras de ;
select 	cast( EXTRACT(MONTH FROM de.fecha_creacion) || '/' || EXTRACT(DAY FROM de.fecha_creacion) || '/' || EXTRACT(YEAR FROM de.fecha_creacion)
	 as varchar(500))
	from documentos_extras de where de.id_proyecto =35 and de.estado and de.id_nivel =120;
--120
select np.id_niveles_pro  
from flujo_proyecto fp 
inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
inner join estado_nivel en on np.id_niveles_pro = en.id_nivel 
inner join niveles n on np.id_nivel =n.id_nivel 
where fp.id_proyecto =35 and fp.estado order by en.id_estado desc limit 1;

---ya estan listo los procesos para subir un archivo extra al proyecto dependiendo del nviel que se encuentre 
--insertar 
call insertar_documentos_extras('../../uploads/proyectos/ilovepdf_merged-1691387847266.pdf','35','segundo extra');
--ver los documentos
select * from Ver_documentos_extras(35);


select *from documentos_extras de;




select * from Ver_URL_Extra(2);
--funcion para retornar la url de un documento segun el id del extra 
create or replace function Ver_URL_Extra(p_id_extra int)
returns table
(
	p_url_doc varchar(800)
)
language 'plpgsql'
as
$BODY$
begin
	--obtener el id del nivel para insertar el registo en la tabla
	return query
	select de.url_doc  from documentos_extras de where de.id_documento_extra = p_id_extra and de.estado ;
end;
$BODY$


--actualizar todos los estados de los documentos extras a false xq me dio un error jajsjjsjs xd skere modo diablo

select * from documentos_extras de ;

update documentos_extras set estado = false 
--cuando se rechaze un proyecto en cualquier nivel se debe de actualizar los estados de los documentos extras a false dependeneideno del id del proyecto 



--funcion que devuelva todos los archivos extras habilitados segun el id del proyecto 
-- estos de aqui tienen que ir en orden para juntarlos con el archivo principal
select * from documentos_extras de where de.id_proyecto =35 and de.estado;
--en el mismo procedimiento almacenado para aceptar el proyecto se tiene que cambiar todos los archivos extras a false para anadir nuevos
--alli mismo se actualiza la ruta del archivo modificado por el nuevo archivo que tiene todos los archivos juntos

--consulta que retorne el pdf activo de un proyecto mediante el id del proyecto 
--tiene que retornar el pdf de la columna modificado 
select dp.url_modificado  from
proyectos p 
inner join documentos_proyectos dp on p.id_proyecto = dp.id_proyecto 
where p.id_proyecto = 35 and dp.estado ;

--funcion para ver la ultima URl modifica segun del id del proyecto 
DROP FUNCTION ver_doc_modificado(integer);
create or replace function ver_doc_modificado(p_id_proyecto int)
returns table
(
	p_url_doc varchar(800), p_titulo varchar(800)
)
language 'plpgsql'
$BODY$
begin
	--obtener el id del nivel para insertar el registo en la tabla
	return query
	select dp.url_modificado  , p2.titulo from
	proyectos p 
	inner join documentos_proyectos dp on p.id_proyecto = dp.id_proyecto 
	inner join proyectos p2 on dp.id_proyecto =p2.id_proyecto 
	where p.id_proyecto = p_id_proyecto and dp.estado ;
end;
$BODY$

select * from ver_doc_modificado(35);
select * from Ver_documentos_extras(35);

	select dp.url_modificado, p2.titulo  from
	proyectos p 
	inner join documentos_proyectos dp on p.id_proyecto = dp.id_proyecto 
	inner join proyectos p2 on dp.id_proyecto =p2.id_proyecto 
	where p.id_proyecto = 35 and dp.estado ;




select * from grupo_proyecto gp ;
--eliminar los constraint de la tabla grupo proyecto
--eliminar los constraint de la tabla participantes 
 ALTER TABLE participantes DROP CONSTRAINT participantes_pkey ;

 ALTER TABLE participantes DROP CONSTRAINT fk_grupo_participantes ;

select * from participantes p ;
--

 ALTER TABLE grupo_proyecto DROP CONSTRAINT fk_proyecto_grupo ;

drop table grupo_proyecto ;


--anadir un campo id_proyecto a participante y juntarlo con la tabla proyecto 
--skere
 ALTER TABLE participantes  ADD COLUMN id_proyecto int constraint;

ALTER TABLE participantes 
ADD COLUMN id_proyecto int;

--eliminar el campo id grupo de participantes 

ALTER TABLE participantes  
DROP COLUMN id_grupo;

alter table participantes add constraint fk_id_proyecto FOREIGN KEY (id_proyecto) 
references proyectos(id_proyecto);


select * from proyectos p ;

select * from proyectos p where p.id_proyecto =2;

--------------------------------------------//////// ROLES USUARIO PROYECTO - NIVEL -////////-----------------------------------------

--cuando se crea un proyecto el primer usuario que debe ser ingresado como participante debe ser el adminsitrador del area 
--consulta para sacar el admin de un area segun el proyecto 
----USUARIO ADMIN DE UN PROYECTO 
--con esto obtengo el id de la relacion que necesita la tabla participante para relacion el usuario con el proyecto 
select ua.id_relacion , ua.id_usuario 
from proyectos p 
inner join usuarios_areas ua on p.id_area_responsable =ua.id_area 
where p.id_proyecto =24 and ua.estado and ua.rol_area ;
select * from participantes p ;

--hacer un trigger after insert en la tabla proyectos para insertar este usuario a los participantes

create or replace function insert_user_admin_proyect() returns trigger 
as 
$$
---Declarar variables
declare
	p_id_relacion int;
begin
		--insertar el usuario admin del proyecto a la tabla participantes depues de crear un proyecto 
	--primer obtener el id relacion
		select into p_id_relacion ua.id_relacion 
		from proyectos p 
		inner join usuarios_areas ua on p.id_area_responsable =ua.id_area 
		where p.id_proyecto =new.id_proyecto and ua.estado and ua.rol_area ;
		--ahora insertar ese usuario en la tabla participantes
		insert into participantes(id_rol,id_relacion_usu_ar,id_proyecto) values (1,p_id_relacion,new.id_proyecto);
return new;
end
$$
language 'plpgsql';


select * from roles r ;
select * from participantes p2 ;
select *from proyectos p ;

create trigger InsUsuarioAdminProyect
after insert 
on proyectos
for each row 
execute procedure insert_user_admin_proyect();


DROP TRIGGER InsProyecto
ON proyectos;
--eliminar funcion
DROP FUNCTION create_proyect_prefij();



--CON ESTA CONSULTA SE OBTIENE TODA LA INFO SOBRE EL USUARIO PRYOECTO Y SU ROL
--comprobar el trigger 
select u.nombres , ad.nombre_area , p2.titulo , r.rol 
from participantes p
inner join usuarios_areas ua on p.id_relacion_usu_ar =ua.id_relacion 
inner join usuario u on ua.id_usuario =u.id_user 
inner join area_departamental ad on ua.id_area =ad.id_area 
inner join proyectos p2 on p.id_proyecto =p2.id_proyecto 
inner join roles r  on p.id_rol =r.id_rol 
where p.estado
;

select * from flujo_proyecto fp where fp.estado ;
--proyecto 24 
select * 
from flujo_proyecto fp 
where fp.id_proyecto = 24 and fp.estado ;

select * from participantes p2 ;
select * from participantes p where p.id_proyecto =24 and p.estado ;

--insertar todos los administradores de areas en los proyectos existentes 
select * from participantes p2 ;
select  ua.id_relacion , u.nombres , ad.nombre_area 
		from proyectos p 
		inner join usuarios_areas ua on p.id_area_responsable =ua.id_area 
		inner join usuario u on ua.id_usuario =u.id_user 
		inner join area_departamental ad ON p.id_area_responsable =ad.id_area 
		where p.id_proyecto =36 and ua.estado and ua.rol_area ;
select p.id_proyecto ,p.titulo ,ad.nombre_area  from proyectos p 
inner join area_departamental ad on p.id_area_responsable =ad.id_area ;

--insert into 
--id rol = 1
insert into participantes (id_relacion_usu_ar,id_proyecto,id_rol) 
values(137,36,1);
select * from participantes p ;
select * from proyectos p ;



delete from participantes where id_participantes =1;


--consulta para ver en que nivel se encuentra un usuario solo con el id del proyecto
--esta consulta puede funcionar tambien con el id del area o con el id del usuario 
--id proyecto 35 
select u.nombres , ad.nombre_area , n.titulo , p2.titulo 
from participantes p 
inner join proyectos p2 on p2.id_proyecto =p.id_proyecto 
inner join flujo_proyecto fp on p2.id_proyecto = fp.id_proyecto 
inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
inner join usuarios_areas ua on p.id_relacion_usu_ar = ua.id_relacion 
inner join niveles n on np.id_nivel =n.id_nivel 
inner join usuario u on ua.id_usuario =u.id_user 
inner join area_departamental ad on ua.id_area = ad.id_area 
where p.id_proyecto =35 and fp.estado and np.id_departamento =ua.id_area and p.estado  ;



select * from proyectos p ;
---consulta para ver a los usuarios que no estan dentro del proyecto segun el id del proyecto y el id del 
--todos los usuarios de un area 
--35----> id proyecto 
--58----> id area

--datos que se necesitan para ver la lista 
--nombres
--correo personal
--correo institucional-
--firma
--identificacion numero
--celular
select u.id_user , u.nombres ,u.correo_personal ,u.correo_institucional ,u.nombre_firma ,u.identificacion ,u.numero_celular  
from usuarios_areas ua 
inner join usuario u on ua.id_usuario =u.id_user 
where ua.id_area =58 and ua.estado ;
--ahora se necesita la lista de los usuarios que ya estan el proyecto para restarla xd jaja skere modo diablo 
--35----> id proyecto 
select u.id_user , u.nombres ,u.correo_personal ,u.correo_institucional ,u.nombre_firma ,u.identificacion ,u.numero_celular  
from participantes p 
inner join usuarios_areas ua on p.id_relacion_usu_ar =ua.id_relacion 
inner join usuario u on ua.id_usuario =u.id_user 
where p.id_proyecto =35 and ua.estado and p.estado ;


--hacer la resta de las dos tablas xdxdxd skere modo diablo ajjajajaj skere Maholy 
select u.id_user , u.nombres ,u.correo_personal ,u.correo_institucional ,u.nombre_firma ,u.identificacion ,u.numero_celular, ua.id_relacion  
from usuarios_areas ua 
inner join usuario u on ua.id_usuario =u.id_user 
where ua.id_area =58 and ua.estado
except 
select cast(u.id_user as varchar(800)) , u.nombres ,u.correo_personal ,u.correo_institucional ,u.nombre_firma ,u.identificacion ,u.numero_celular, ua.id_relacion  
from participantes p 
inner join usuarios_areas ua on p.id_relacion_usu_ar =ua.id_relacion 
inner join usuario u on ua.id_usuario =u.id_user 
where p.id_proyecto =35 and ua.estado and p.estado ;




--funcion para agregar participantes 
create or replace function Lista_Participantes_Proyecto(p_id_area int, p_id_proyecto int)
returns table
(
	r_id_user varchar(800), r_nombres varchar(800), r_correo_personal varchar(800), r_correo_institucional varchar(800), r_nombre_firma varchar(800),r_identificacion varchar(800), r_numero_celular varchar(800), r_id_realcion int
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select cast(u.id_user as varchar(800)) , u.nombres ,u.correo_personal ,u.correo_institucional ,u.nombre_firma ,u.identificacion ,u.numero_celular, ua.id_relacion  
	from usuarios_areas ua 
	inner join usuario u on ua.id_usuario =u.id_user 
	where ua.id_area =p_id_area and ua.estado
	except 
	select cast(u.id_user as varchar(800)) , u.nombres ,u.correo_personal ,u.correo_institucional ,u.nombre_firma ,u.identificacion ,u.numero_celular, ua.id_relacion  
	from participantes p 
	inner join usuarios_areas ua on p.id_relacion_usu_ar =ua.id_relacion 
	inner join usuario u on ua.id_usuario =u.id_user 
	where p.id_proyecto =p_id_proyecto and ua.estado and p.estado and ua.id_area =p_id_area;
end;
$BODY$

--funcion que retorne la lista de los participantes actuales que tiene un proyecto 
DROP FUNCTION participantes_actuales_proyecto(integer)

create or replace function Participantes_Actuales_Proyecto(p_id_area int, p_id_proyecto int)
returns table
(
	r_id_user varchar(800), r_nombres varchar(800), r_correo_personal varchar(800), r_correo_institucional varchar(800), r_nombre_firma varchar(800),r_identificacion varchar(800), r_numero_celular varchar(800), r_id_realcion int, r_rol varchar(50)
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select cast(u.id_user as varchar(800)) , u.nombres ,u.correo_personal ,u.correo_institucional ,u.nombre_firma ,u.identificacion ,u.numero_celular, ua.id_relacion  ,r.rol
	from participantes p 
	inner join usuarios_areas ua on p.id_relacion_usu_ar =ua.id_relacion 
	inner join usuario u on ua.id_usuario =u.id_user 
		inner join roles r on p.id_rol = r.id_rol 
	where p.id_proyecto =p_id_proyecto and ua.estado and p.estado and ua.id_area =p_id_area;
end;
$BODY$



--hacer la funcion que retorne todos los usuarios de un area para agregarlos al proyecto 
--esta funcion retorna todos los usuarios que no estan el proyecto
select * from Lista_Participantes_Proyecto(58,35);
--esta fucnion retorna todos los usuario que si estan en el proyecto
select * from Participantes_Actuales_Proyecto(58,35);


select cast(u.id_user as varchar(800)) , u.nombres ,u.correo_personal ,u.correo_institucional ,u.nombre_firma ,u.identificacion ,u.numero_celular, ua.id_relacion, r.rol  
	from participantes p 
	inner join usuarios_areas ua on p.id_relacion_usu_ar =ua.id_relacion 
	inner join usuario u on ua.id_usuario =u.id_user 
	inner join roles r on p.id_rol = r.id_rol 
	where p.id_proyecto =35 and ua.estado and p.estado and ua.id_area =58 ;
	

--procedimiento almacenado para agregar usuarios a un proyecto 
select * from participantes p ;
---		insert into participantes(id_rol,id_relacion_usu_ar,id_proyecto) values (1,p_id_relacion,new.id_proyecto);

Create or Replace Procedure agregar_usuario_proyecto(
										p_proyecto_id int,
										p_id_relacion int,
										p_id_rol int
										  )
Language 'plpgsql'
AS $$
begin
	--insertar el user xd 
	insert into participantes(id_rol,id_relacion_usu_ar,id_proyecto) values (p_id_rol,p_id_relacion,p_proyecto_id);
	EXCEPTION
        -- Si ocurre un error en la transacción principal, revertir
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE EXCEPTION 'Ha ocurrido un error en la transacción principal: %', SQLERRM;	
END;
$$;

select * from roles r ;
--  2--> revisor
--  3--> editor

--trigger after insert 
--crear un trigger que anada al historial del proyecto la aleerta de que se anadio un usuario al proyecto 
--esto despues de haberlo ingresado a la tabla participantes 
--consulta para saber los datos del usuario que se esta ingresando 

--se necesita el nombre del usuario y el rol que se le dio cuando se ingresa 
select u.nombres , r.rol  
from participantes p 
inner join usuarios_areas ua on p.id_relacion_usu_ar =ua.id_relacion 
inner join usuario u on ua.id_usuario =u.id_user 
inner join roles r on p.id_rol = r.id_rol 
where p.id_relacion_usu_ar  = 137 and p.id_proyecto = 24 and p.estado ;

--creacion del trigger para que ingrese al historial 
create or replace function historial_new_user_proyect() returns trigger 
as 
$$
---Declarar variables
declare
	p_nombres varchar(500);
	p_rol varchar(50);
begin	
		--primero obtener los datos que se mostraran en el detalle
		select u.nombres , r.rol  into p_nombres,p_rol
		from participantes p 
		inner join usuarios_areas ua on p.id_relacion_usu_ar =ua.id_relacion 
		inner join usuario u on ua.id_usuario =u.id_user 
		inner join roles r on p.id_rol = r.id_rol 
		where p.id_relacion_usu_ar  = new.id_relacion_usu_ar and p.id_proyecto = new.id_proyecto and p.estado ;
		--ahora insertar el historial
	insert into historial_proyecto (detalle,boton,tipo,id_proyecto,Descripcion, titulo)
	values (concat('Se agregó al usuario: ',p_nombres, ' con el rol: ',p_rol),false,8,new.id_proyecto,'Se añade un usuario','Añadir usuario');
		return new;
end
$$
language 'plpgsql';

create trigger InsUserProyect
after insert 
on participantes
for each row 
execute procedure historial_new_user_proyect();

select * from participantes p ;
select * from historial_proyecto hp ;
insert into historial_proyecto (detalle,boton,tipo,id_proyecto,Descripcion, titulo)
	values (concat('El area: ',p_nombre_area, ' creó el proyecto : ',p_titulo),false,1,p_id_proyecto,'Se crea un proyecto','Creación del proyecto');



--funcion para expulsar a un usuario de un proyecto 
--se puede expulsar el participante segun el id de relacion y el id del proyecto 
--cambiar a false
select * from participantes p where p.id_proyecto =24 and id_relacion_usu_ar =137;

--creacion del procedimiento para cambiar el estado del usuario 
Create or Replace Procedure expulsar_usuario_proyecto(
										p_proyecto_id int,
										p_id_relacion int
										  )
Language 'plpgsql'
AS $$
declare
	p_nombres varchar(500);
begin
	--obtener los datos para ponerlos en el historial 
		select u.nombres   into p_nombres
		from participantes p 
		inner join usuarios_areas ua on p.id_relacion_usu_ar =ua.id_relacion 
		inner join usuario u on ua.id_usuario =u.id_user 
		where p.id_relacion_usu_ar  = p_id_relacion and p.id_proyecto = p_proyecto_id and p.estado ;
	--hacer el update 
	update participantes  set estado = false where id_proyecto=p_proyecto_id and id_relacion_usu_ar=p_id_relacion;
	--insertar al historial el usuario que se expulso ajjaj xd skere modo diablo 
	insert into historial_proyecto (detalle,boton,tipo,id_proyecto,Descripcion, titulo)
	values (concat('Se expulsó al usuario: ',p_nombres),false,9,p_proyecto_id,'Se expulsó un usuario','Expulsión de usuario');

	EXCEPTION
        -- Si ocurre un error en la transacción principal, revertir
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE EXCEPTION 'Ha ocurrido un error en la transacción principal: %', SQLERRM;	
END;
$$;




---
select u.nombres , ad.nombre_area , n.titulo , p2.titulo 
from participantes p 
inner join proyectos p2 on p2.id_proyecto =p.id_proyecto 
inner join flujo_proyecto fp on p2.id_proyecto = fp.id_proyecto 
inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
inner join usuarios_areas ua on p.id_relacion_usu_ar = ua.id_relacion 
inner join niveles n on np.id_nivel =n.id_nivel 
inner join usuario u on ua.id_usuario =u.id_user 
inner join area_departamental ad on ua.id_area = ad.id_area 
where p.id_proyecto =35 and fp.estado and np.id_departamento =ua.id_area and p.estado  ;
--




select * from empresa e ;



--funcion para retornar la lista de los participantes de un proyecto 
select u.nombres ,u.nombre_firma , n.titulo 
from participantes p 
inner join proyectos p2 on p2.id_proyecto =p.id_proyecto 
inner join flujo_proyecto fp on p2.id_proyecto = fp.id_proyecto 
inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
inner join usuarios_areas ua on p.id_relacion_usu_ar = ua.id_relacion 
inner join niveles n on np.id_nivel =n.id_nivel 
inner join usuario u on ua.id_usuario =u.id_user 
inner join area_departamental ad on ua.id_area = ad.id_area 
where p.id_proyecto =37 and fp.estado and np.id_departamento =ua.id_area and p.estado;

--aqui crear la funcion que retorne la lista de los participantes mediante el id del proyecto 

select * from proyectos p ;
select * from participantes_proyecto(37);




create or replace function participantes_proyecto(p_id_proyecto int)
returns table
(
	r_nombres_participantes varchar(800), r_firma_participantes varchar(800)
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select u.nombres ,u.nombre_firma 
	from participantes p 
	inner join proyectos p2 on p2.id_proyecto =p.id_proyecto 
	inner join flujo_proyecto fp on p2.id_proyecto = fp.id_proyecto 
	inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
	inner join usuarios_areas ua on p.id_relacion_usu_ar = ua.id_relacion 
	inner join niveles n on np.id_nivel =n.id_nivel 
	inner join usuario u on ua.id_usuario =u.id_user 
	inner join area_departamental ad on ua.id_area = ad.id_area 
	where p.id_proyecto =p_id_proyecto and fp.estado and np.id_departamento =ua.id_area and p.estado;
end;
$BODY$

--funcinon para obtener el titulo del proyecto mediante el id 
select p.titulo  from proyectos p where p.id_proyecto =35;


select * from titulo_proyecto_pdf(35);
create or replace function titulo_proyecto_pdf(p_id_proyecto int)
returns table
(
	r_titulo_proyecto varchar(800)
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select p.titulo  from proyectos p where p.id_proyecto =p_id_proyecto;
end;
$BODY$

delete from publicacion_proyecto ;
select * from publicacion_proyecto pp ;


--hacer tres funciones 
--1.-TODOS LOS USUARIOS QUE PARTICIPARON EN ELABORACION
--2.-LOS USUARIOS AMINISTRADORES DE REVISION YA SEA UNICA O REVISION MULTIPLE
--3.-EL USUARIO AMINISTRADOR DE PUBLICACION

--primer funcion la mas easy 
--ejemplo proyecto 37
--tipos de niveles : 
--	1 = Elaboracion
--  2 = Revision da igual la cardinalidad
--  3 = Publicacion 
--tipos de roles: 
--  1 = Admin p.id_rol
select u.nombres ,u.nombre_firma , n.titulo , p.id_rol 
from participantes p 
inner join proyectos p2 on p2.id_proyecto =p.id_proyecto 
inner join flujo_proyecto fp on p2.id_proyecto = fp.id_proyecto 
inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
inner join usuarios_areas ua on p.id_relacion_usu_ar = ua.id_relacion 
inner join niveles n on np.id_nivel =n.id_nivel 
inner join usuario u on ua.id_usuario =u.id_user 
inner join area_departamental ad on ua.id_area = ad.id_area 
where p.id_proyecto =37 and fp.estado and np.id_departamento =ua.id_area and p.estado and n.tipo_nivel =1;

--creacion primera funcion : 
create or replace function listado_usuarios_elaboracion(p_id_proyecto int)
returns table
(
	r_nombre_firma varchar(800)
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select u.nombre_firma
	from participantes p 
	inner join proyectos p2 on p2.id_proyecto =p.id_proyecto 
	inner join flujo_proyecto fp on p2.id_proyecto = fp.id_proyecto 
	inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
	inner join usuarios_areas ua on p.id_relacion_usu_ar = ua.id_relacion 
	inner join niveles n on np.id_nivel =n.id_nivel 
	inner join usuario u on ua.id_usuario =u.id_user 
	inner join area_departamental ad on ua.id_area = ad.id_area 
	where p.id_proyecto =p_id_proyecto and fp.estado and np.id_departamento =ua.id_area and p.estado and n.tipo_nivel =1;
end;
$BODY$
--creacion segunda funcion que retorne USUARIOS ADMINISTRADORES DE REVISION
create or replace function listado_usuarios_revision(p_id_proyecto int)
returns table
(
	r_nombre_firma varchar(800)
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select u.nombre_firma 
	from participantes p 
	inner join proyectos p2 on p2.id_proyecto =p.id_proyecto 
	inner join flujo_proyecto fp on p2.id_proyecto = fp.id_proyecto 
	inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
	inner join usuarios_areas ua on p.id_relacion_usu_ar = ua.id_relacion 
	inner join niveles n on np.id_nivel =n.id_nivel 
	inner join usuario u on ua.id_usuario =u.id_user 
	inner join area_departamental ad on ua.id_area = ad.id_area 
	where p.id_proyecto =p_id_proyecto and fp.estado and np.id_departamento =ua.id_area and p.estado and n.tipo_nivel =2 and p.id_rol =1;
end;
$BODY$
--creacion tercera funcion que retorne USUARIO ADMINISTRADOR DE PUBLICACION
create or replace function listado_usuarios_publicacion(p_id_proyecto int)
returns table
(
	r_nombre_firma varchar(800)
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select u.nombre_firma 
	from participantes p 
	inner join proyectos p2 on p2.id_proyecto =p.id_proyecto 
	inner join flujo_proyecto fp on p2.id_proyecto = fp.id_proyecto 
	inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
	inner join usuarios_areas ua on p.id_relacion_usu_ar = ua.id_relacion 
	inner join niveles n on np.id_nivel =n.id_nivel 
	inner join usuario u on ua.id_usuario =u.id_user 
	inner join area_departamental ad on ua.id_area = ad.id_area 
	where p.id_proyecto =p_id_proyecto and fp.estado and np.id_departamento =ua.id_area and p.estado and n.tipo_nivel =3 and p.id_rol =1;
end;
$BODY$

--funcion para el encabezado de la paguina que contiene los integrantes del proyecto
select * from empresa e ;
--retornar los datos de la empresa jajaja skere modo diablo 
select * from encabezado_empresa_pdf();
create or replace function encabezado_empresa_pdf()
returns table
(
	r_nombre_empresa varchar(800), r_url_logo varchar(800)
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select e.nombre , e.url_logo  from empresa e ;
	end;
$BODY$


--aqui agregar lo de la base de datos de John WIck

CREATE OR REPLACE FUNCTION generar_uuid_id() RETURNS TEXT AS $$
DECLARE
    caracteres TEXT := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@$!%*?&';
    contraseña_generada TEXT := '';
BEGIN
    LOOP
        -- Generar la contraseña
        contraseña_generada := '';
        FOR i IN 1..10 LOOP  -- Generar exactamente 10 caracteres
            contraseña_generada := contraseña_generada || substr(caracteres, floor(random() * length(caracteres) + 1)::int, 1);
        END LOOP;

        -- Salir del bucle si la contraseña cumple con los requisitos y tiene exactamente 10 caracteres
        IF LENGTH(contraseña_generada) = 10 AND contraseña_generada ~ '^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+$' THEN
            RAISE NOTICE 'Contraseña generada: %', contraseña_generada;
            EXIT;
        END IF;
    END LOOP;
    RETURN contraseña_generada;
END;
$$ LANGUAGE PLPGSQL;




----------modificar el procedimiento para la creacion de usarios, agregando las contraseñas aleatorias

CREATE OR REPLACE PROCEDURE public.crear_usuario(
	IN p_nombres character varying,
	IN p_tipo_identificacion character varying,
	IN p_identificacion character varying,
	IN p_correo1 character varying,
	IN p_correo2 character varying,
	IN p_celular character varying,
	IN p_foto character varying,
	IN p_firma character varying,
	IN p_isadmin boolean)
LANGUAGE 'plpgsql'
AS $BODY$

Begin

if(p_isadmin)
then
	insert into usuario (nombres,tipo_identificacion,identificacion,correo_personal,correo_institucional,numero_celular,url_foto,isadmin,Nombre_firma,Contra)values
	(p_nombres, p_tipo_identificacion,p_identificacion,p_correo1,p_correo2,p_celular,p_foto,p_isadmin,p_firma,
	 PGP_SYM_ENCRYPT(generar_uuid_id()::text,'SGDV_KEY'));
else
	insert into usuario (nombres,tipo_identificacion,identificacion,correo_personal,correo_institucional,numero_celular,url_foto,Nombre_firma,Contra)values
	(p_nombres, p_tipo_identificacion,p_identificacion,p_correo1,p_correo2,p_celular,p_foto,p_firma,
	 PGP_SYM_ENCRYPT(generar_uuid_id()::text,'SGDV_KEY'));
end if;

COMMIT;
END;
$BODY$;
ALTER PROCEDURE public.crear_usuario(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean)
    OWNER TO postgres;

   
   
   
   

CREATE OR REPLACE PROCEDURE public.crear_usuario_area(
	IN p_nombres character varying,
	IN p_tipo_identificacion character varying,
	IN p_identificacion character varying,
	IN p_correo1 character varying,
	IN p_correo2 character varying,
	IN p_celular character varying,
	IN p_foto character varying,
	IN p_firma character varying,
	IN p_id_area character varying)
LANGUAGE 'plpgsql'
AS $BODY$

declare
	ID_A varchar(900);
Begin

	insert into usuario (nombres,tipo_identificacion,identificacion,correo_personal,correo_institucional,numero_celular,url_foto,isadmin,Nombre_firma,Contra)values
	(p_nombres, p_tipo_identificacion,p_identificacion,p_correo1,p_correo2,p_celular,p_foto,false,p_firma,
	 PGP_SYM_ENCRYPT(generar_uuid_id()::text,'SGDV_KEY'));
	 select into ID_A cast(id_user as varchar(900))  from usuario u where identificacion =p_identificacion;
	--registrar en el area 
	insert into usuarios_areas (id_usuario, id_area)values
	(cast(ID_A as uuid),cast(p_id_area as int));

COMMIT;
END;
$BODY$;
ALTER PROCEDURE public.crear_usuario_area(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying)
    OWNER TO postgres;
   
   
   
   
   
   
CREATE OR REPLACE FUNCTION public.contra_user(
	cedula_user character varying, correo_instu character varying)
    RETURNS TABLE(contras character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

begin
	return query
	select PGP_SYM_DECRYPT(contra ::bytea, 'SGDV_KEY')::character varying  from usuario 
	where identificacion = cedula_user and correo_institucional = correo_instu;
end;
$BODY$;





-----------------------funcion para recuperar la cuenta mandado el id de usario segun el correo-----

--DROP FUNCTION IF EXISTS recuperar_cuenta_verificar(character varying);

CREATE OR REPLACE FUNCTION public.recuperar_cuenta_verificar(
	email character varying)
    RETURNS TABLE(verification integer, mensaje character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

declare
	User_Deshabili bool;
	User_Exit bool;

begin
	--Primero Verificar si el correo que se esta ingresando existe
	select into User_Exit case when COUNT(*)>=1 then True else false end  from usuario where correo_institucional=email;	
	if(User_Exit) then
	--Verificar si el usario esta desabilitado
		select into User_Deshabili estado from usuario where correo_institucional=email;
		if (User_Deshabili) then 
			return query
			select
			cast(case when COUNT(*)>=1 then 1 else 2 end as int),
			 cast(case when COUNT(*)>=1 then 'Correo enviado' else 'Correo no enviado' end as varchar(500))
			from usuario
			where correo_institucional  = email
			and estado=true;
   		else 
   			return query
			select cast(3 as int), cast('Usuario deshabilitado contacte con un administrador' as varchar(500));
		end if;
	
	else 
	   		return query
			select cast(4 as int), cast('Este correo no esta registrado' as varchar(500));
	end if;
	
end;
$BODY$;
---------------------------------------------



---------------Funcion para Recuperara la cuenta cambiando la contraseña---------------------

-- DROP PROCEDURE IF EXISTS public.recuperar_cuenta_contra(character varying, character varying);

CREATE OR REPLACE PROCEDURE public.recuperar_cuenta_contra(
	IN p_contra_nueva character varying,
	IN p_email_user character varying)
LANGUAGE 'plpgsql'
AS $BODY$

Begin
update usuario set contra =PGP_SYM_ENCRYPT(p_contra_nueva,'SGDV_KEY')
where correo_institucional = p_email_user;
COMMIT;
END;
$BODY$;




-----------Aumente la validacion de la contraseña vacia al trigger------------

-- DROP FUNCTION IF EXISTS public.tr_insert_user();

CREATE OR REPLACE FUNCTION public.tr_insert_user()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$

begin
	if new.identificacion  ~ '[^0-9]' then 
		raise exception 'Identificacion solo puede tener numeros';
	end if;
	if new.numero_celular  ~ '[^0-9]' then 
		raise exception 'Celular solo puede tener numeros';
	end if;
	if length(new.numero_celular) <> 10 then
		raise exception 'Celular debe tener 10 digitos';
	end if; 
	if trim(new.nombres)='' then
			raise exception 'Nombres no puede ser vacio';
	end if;
	if trim(new.correo_personal)='' then
			raise exception 'Correo personal no puede ser vacio';
	end if;
	if trim(new.correo_institucional)='' then
			raise exception 'Correo institucional no puede ser vacio';
	end if;
	if trim(PGP_SYM_DECRYPT(new.contra ::bytea, 'SGDV_KEY'))='' then
			raise exception 'Contraseña no puede ser vacio';
	ELSIF NOT (trim(PGP_SYM_DECRYPT(new.contra::bytea, 'SGDV_KEY')) ~ '^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+$') THEN
    		raise exception 'La contraseña debe contener al menos una letra, un número, un carácter especial y una mayúscula';
	END IF;	
	if trim(new.url_foto)='' then
			new.url_foto='../../uploads/perfiles/user.png';
	end if;
	if trim(new.nombre_firma)='' then
			raise exception 'Firma no puede ser vacio';
	end if;
	--validar si la imagen es correcta si no otorgar una por default
	if(new.url_foto='../../uploads/perfiles/undefined') then
			new.url_foto='../../uploads/perfiles/user.png';
		end if;
	--validar el tamano de la identificacion dependiendo del tipo
	if(new.tipo_identificacion='Cedula')then
		if length(new.identificacion)<>10 then
					raise exception 'Cedula requiere 10 digitos';
		end if;
	end if;
	if(new.tipo_identificacion='Ruc')then
		if length(new.identificacion)<>13 then
					raise exception 'Ruc requiere 13 digitos';
		end if;
	end if;
	if(new.tipo_identificacion='Pasaporte')then
		if length(new.identificacion)<>12 then
					raise exception 'Pasaporte requiere 12 digitos';
		end if;
	end if;
return new;
end
$BODY$;

ALTER FUNCTION public.tr_insert_user()
    OWNER TO postgres;
  
   

-----------------funcion que me retorna la contraseña segun el usuario por medio del correo para veridicar el token--------------

--DROP FUNCTION IF EXISTS contra_user(character varying,character varying);

CREATE OR REPLACE FUNCTION public.contra_user_token(
	correo_instu character varying)
    RETURNS TABLE(contrat character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
	return query
	select PGP_SYM_DECRYPT(contra ::bytea, 'SGDV_KEY')::character varying  from usuario 
	where correo_institucional = correo_instu;
end;
$BODY$;



---procedure para adjuntar documentos al documento modificado 
--update al campo documento modificado 
select tipo_carta  from documentos_extras de ;
Create or Replace Procedure adjuntar_documentos_proyecto_after(
										p_proyecto_id int,
										p_url_doc varchar(800)
										  )
Language 'plpgsql'
AS $$
declare 
	p_id_documento int;
begin
	--insertar el user xd 
		select  dp.id_documento into p_id_documento from documentos_proyectos dp where dp.id_proyecto =p_proyecto_id and dp.estado ;
	update documentos_proyectos set url_modificado = p_url_doc where id_documento =p_id_documento;
	update documentos_extras set estado = false where id_proyecto =p_proyecto_id and tipo_carta=true;
	EXCEPTION
        -- Si ocurre un error en la transacción principal, revertir
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE EXCEPTION 'Ha ocurrido un error en la transacción principal: %', SQLERRM;	
END;
$$;

--fucnion para ver las contraportadas jajaja skere modo pija 



--crear un nuevo campo en documentos extras para saber si el documento que se quiere anadir es un documento carta osea al final del documento
---o si el documento que se quiere anadir es una contraportada osea despues de la lista de los participantes 
--podria ser un bool para saber si es contraportada 
--modificar esta funcio: Ver_documentos_extras para que solo filtre si es true 
select * from documentos_extras de ;
alter table documentos_extras 
add column tipo_carta bool;


alter table documentos_extras  alter column tipo_carta set default true;
update documentos_extras  set tipo_carta=true ;

 alter table documentos_extras alter column tipo_carta set not null;


--procedure para insertar documentos contraportadas
Create or Replace Procedure insertar_contra_portadas(p_url varchar(200),
										   p_id_proyecto varchar(200),
										   p_descripcion varchar(100)
										   )
Language 'plpgsql'
AS $$
declare 
	p_id_nivel int;
begin
		--obtener el id del nivel para insertar el registo en la tabla
		select into p_id_nivel np.id_niveles_pro
		from flujo_proyecto fp 
		inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
		inner join estado_nivel en on np.id_niveles_pro = en.id_nivel 
		inner join niveles n on np.id_nivel =n.id_nivel 
		where fp.id_proyecto =cast(p_id_proyecto as int) and fp.estado order by en.id_estado desc limit 1;
		--aqui registrar 
		insert into documentos_extras(url_doc, id_proyecto,descripcion,id_nivel,tipo_carta)
		values(p_url,cast(p_id_proyecto as int),p_descripcion,p_id_nivel,false);
	EXCEPTION
        -- Si ocurre un error en la transacción principal, revertir
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE EXCEPTION 'Ha ocurrido un error en la transacción principal: %', SQLERRM;
END;
$$; 

--funcion para ver los documentos contraportadas 
select * from Ver_contraportadas(37);
select * from documentos_extras de ;

select * from proyectos p ;
create or replace function Ver_contraportadas(p_id_proyecto int)
returns table
(
	r_id_documento_extra int, r_url_doc varchar(800), r_estado bool, r_descripcion varchar(800), r_id_nivel int, r_fecha_creacion varchar(800)
)
language 'plpgsql'
as
$BODY$
declare 
	p_id_nivel int;
begin
	--obtener el id del nivel para insertar el registo en la tabla
		select np.id_niveles_pro  into p_id_nivel
		from flujo_proyecto fp 
		inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
		inner join estado_nivel en on np.id_niveles_pro = en.id_nivel 
		inner join niveles n on np.id_nivel =n.id_nivel 
		where fp.id_proyecto =p_id_proyecto and fp.estado order by en.id_estado desc limit 1;
	return query
	select 
	de.id_documento_extra , de.url_doc , de.estado  , de.descripcion , de.id_nivel,
		cast( EXTRACT(MONTH FROM de.fecha_creacion) || '/' || EXTRACT(DAY FROM de.fecha_creacion) || '/' || EXTRACT(YEAR FROM de.fecha_creacion)
	 as varchar(500))
	from documentos_extras de where de.id_proyecto =p_id_proyecto and de.estado and de.id_nivel =p_id_nivel and de.tipo_carta=false;
end;
$BODY$

update documentos_extras set estado = false where id_documento_extra =20;
select * from documentos_extras de ;
select dp.id_documento  from documentos_proyectos dp where dp.id_proyecto =24 and dp.estado ;

--../../uploads/proyectos/Caratula1693386701709.pdf
--../../uploads/proyectos/APROBACION PUBLICACION-1693385435990-Cabezera.pdf
--actualizar el documento cuando se lo prepara xdxdxd skere modo diablo 
---solo actualizar el nuevo url documento y los estados a false de todos los documentos extras
--fp.id_proyecto =cast(p_id_proyecto as int)

select * from firma_proyecto fp ;
select * from firma_participantes fp ;
select p.documento_preparado  from proyectos p ; 
Create or Replace Procedure aceptar_documento(p_url varchar(200),
										   p_id_proyecto varchar(200)
										   )
Language 'plpgsql'
AS $$
declare 
	p_id_firma int; 
begin
		--actualizar la ur segun el id documento
	update documentos_proyectos  set url_modificado =p_url  where id_proyecto =cast(p_id_proyecto as int)  and estado ; 
	--actualizar el estado de los documentos extras a false 
	update documentos_extras set estado = false where id_proyecto=cast(p_id_proyecto as int);
		--primero actualizar el nuevo url documento modificado segun el id del proyecto 
	--como se esta preparando el documento se debe habilitar las firmas y actualizar el campo de documento preparado de la tabla proyecto como true 
	update proyectos set documento_preparado= true  where id_proyecto = cast(p_id_proyecto as int);
	--ahora enviarle el id del proyecto y el id de la firma al cursor 
 	PERFORM anadir_participantes_firma(cast(p_id_proyecto as int));
	--hacer un cursor que anada todos los participantes de elaboracion y todos los participantes administradores de revision xdxd skere modo diablo
	EXCEPTION
        -- Si ocurre un error en la transacción principal, revertir
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE EXCEPTION 'Ha ocurrido un error en la transacción principal: %', SQLERRM;
END;
$$; 

--cursor para anadir a todos los participantes de un proyecto a la tabla firma con la conidciones 
--anadir_participantes_firma(p_id_proyecto,p_id_firma);
--funcion para el cursor 
select * from firma_participantes fp2 ;
CREATE OR REPLACE FUNCTION anadir_participantes_firma(p_id_proyecto int)
RETURNS VOID AS
$$
DECLARE 
    --nuevo 
  	p_id_usuario uuid;
    p_id_firma int;
 	P_id_flujo_new int;
    	curCopiar cursor for select u.id_user   from participantes p 
												inner join proyectos p2 on p2.id_proyecto =p.id_proyecto 
												inner join flujo_proyecto fp on p2.id_proyecto = fp.id_proyecto 
												inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
												inner join usuarios_areas ua on p.id_relacion_usu_ar = ua.id_relacion 
												inner join niveles n on np.id_nivel =n.id_nivel 
												inner join usuario u on ua.id_usuario =u.id_user 
												inner join area_departamental ad on ua.id_area = ad.id_area 
												where p.id_proyecto =p_id_proyecto and fp.estado and np.id_departamento =ua.id_area and p.estado and (n.tipo_nivel =1 or (n.tipo_nivel =2 and p.id_rol=1)or (n.tipo_nivel =3 and p.id_rol=1))
 												order by n.tipo_nivel asc ;
    
begin
	--insertar un nuevo registro en firma proyecto y obtener su id para enviarlo al cursor que anada a todos los usuarios para que puedan firmar 
	insert into firma_proyecto(id_proyecto) values (p_id_proyecto);
	--ahora obtener el ulitimo id del registro 
	select f.id_firma into p_id_firma from firma_proyecto f where f.estado order by f.id_firma desc limit 1;
	
   open curCopiar;
	fetch next from curCopiar into p_id_usuario;
	while (Found) loop	
		--aqui insertar el registro en la tabla firmas usuarios 
		insert into firma_participantes(id_usuario,id_firma) values(p_id_usuario,p_id_firma);
		--cerrar el cursor 
	fetch curCopiar into p_id_usuario;
	end loop;
	close curCopiar;
	EXCEPTION
        -- Si ocurre un error en la transacción principal, revertir
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE EXCEPTION 'Ha ocurrido un error: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


--consulta para obtener todos los participantes de un proyecto tanto de elaboracion como administradors de areas superiores 
select * from proyectos p ;
-- idproyecto = 42
select * from participantes p where p.id_proyecto =42 and p.estado ;

--funcines que enlistan los usuarios dependiendo de su nivel y si son admins o no 
--todos los usuarios participantes (elaboracion todos, revision solo los admins y publicacion solo los admins)
select  u.id_user , u.nombre_firma, n.titulo 
	from participantes p 
	inner join proyectos p2 on p2.id_proyecto =p.id_proyecto 
	inner join flujo_proyecto fp on p2.id_proyecto = fp.id_proyecto 
	inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
	inner join usuarios_areas ua on p.id_relacion_usu_ar = ua.id_relacion 
	inner join niveles n on np.id_nivel =n.id_nivel 
	inner join usuario u on ua.id_usuario =u.id_user 
	inner join area_departamental ad on ua.id_area = ad.id_area 
	where p.id_proyecto =42 and fp.estado and np.id_departamento =ua.id_area and p.estado and (n.tipo_nivel =1 or (n.tipo_nivel =2 and p.id_rol=1)or (n.tipo_nivel =3 and p.id_rol=1))
 	order by n.tipo_nivel asc ;

--admins de revision 
select u.id_user , u.nombre_firma, n.titulo 
	from participantes p 
	inner join proyectos p2 on p2.id_proyecto =p.id_proyecto 
	inner join flujo_proyecto fp on p2.id_proyecto = fp.id_proyecto 
	inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
	inner join usuarios_areas ua on p.id_relacion_usu_ar = ua.id_relacion 
	inner join niveles n on np.id_nivel =n.id_nivel 
	inner join usuario u on ua.id_usuario =u.id_user 
	inner join area_departamental ad on ua.id_area = ad.id_area 
	where p.id_proyecto =42 and fp.estado and np.id_departamento =ua.id_area and p.estado and n.tipo_nivel =2 and p.id_rol =1;



--agregar una nueva columna a la tabla proyectos para la version xdxd skere modo diablo 
--columna_decimal DECIMAL(3, 1)
select * from proyectos p ;
alter table proyectos 
add column versionp DECIMAL(5, 1);
 alter table proyectos alter column versionp set not null;

update proyectos set versionp=1.0 ;

--con esto se muestra en char el decimal con ,0
select TO_CHAR(p.versionp, 'FM999D0') from proyectos p ;

--pro_encabezado


select * from ver_proyectos_publicados();

select pp.id_publicacion, pp.url_doc,cast(TO_CHAR(pp.fecha_publicacion, 'DD-MON-YYYY') as varchar(500)) ,p.titulo ,p.codigo, cp.nombre_categoria , cp.prefijo_categoria ,
		ad.nombre_area ,ad.prefijo_departamento 
		from publicacion_proyecto pp
		inner join proyectos p on pp.id_proyecto = p.id_proyecto 
		inner join categorias_proyecto cp on p.id_categoria =cp.id_categoria 
		inner join area_departamental ad on p.id_area_responsable =ad.id_area 
		where pp.estado=true order by pp.fecha_publicacion asc;
		end;
		
select * from publicacion_proyecto pp ;


--Modificacion para la tabla las publicaciones del proyecto: 
--anadir la version del proyecto (la actual)
alter table publicacion_proyecto 
add column versionp DECIMAL(5, 1);
-- anadir el id del flujo
alter table publicacion_proyecto 
add column id_flujo int;
--anadir el campo titulo del proyecto 
alter table publicacion_proyecto 
add column titulo_publicacion varchar(800);
--anadir los set not null 
 alter table publicacion_proyecto alter column versionp set not null;
 alter table publicacion_proyecto alter column id_flujo set not null;
 alter table publicacion_proyecto alter column titulo_publicacion set not null;


select * from flujo_proyecto fp ;
--conectar la tabla publicacion con flujo de proyecto 
alter table publicacion_proyecto add constraint FK_FLujo_Proyecto foreign key (id_flujo) references flujo_proyecto(id_flujo);

select * from publicacion_proyecto pp inner join flujo_proyecto fp on pp.id_flujo =fp.id_flujo ;

select * from tipos_jerarquia tj ;
--anadir un campo valor del flujo decimal 5.1 para saber cuanto se le tiene que sumar a un proyecto cuando se haga reforma:
alter table tipos_jerarquia 
add column valor DECIMAL(5, 1);
 alter table publicacion_proyecto alter column titulo_publicacion set not null;

--anadirle valores a tipos jerarquia 
--Los valores para reformas van segun sus niveles, en el flujo ideal como tiene 2 o mas niveles de revision pesa mas el cambio entonces se le suma 1.0
--en flujo unico como solo un area revisa el documento entonces seria 0.5 porque no tiene mucho peso
--si se crea un flujo el cual solo pase hasta publicacion osea asi: elaboracion -> publicacion valdria 0.1 porque no es un cambio grande
update tipos_jerarquia set valor=1.0 where id_tipo = 6;
update tipos_jerarquia set valor=0.5 where id_tipo = 10;
--los flujos que no sirven que estan creados ponerle valor 0 
update tipos_jerarquia set valor=0 where id_tipo = 4;
update tipos_jerarquia set valor=0 where id_tipo = 8;
update tipos_jerarquia set valor=0 where id_tipo = 9;


select * from proyectos p ;
--crear un novo campo para saber si el proyecto se ha publicado o no
--no combie cambiarle el nombre al compo subir_docs porque esta conectado a varias dependencias
alter table proyectos 
add column publicado bool;

 alter table proyectos alter column publicado set default false;

update proyectos set publicado = true where id_proyecto =39 ;
select pp.id_proyecto  from publicacion_proyecto pp ;
--cmabiar el estado a todos los proyectos menos al que ya esta publicado y el que se va a realizar las pruebas 
update proyecto 

--Listar los proyectos publicados para realizarles reformas 

--Listar las publicaciones para hacerles reformas 
	---Titulo
	--Area encargada
	--Categoria nombre y codigo
	--Codigo del proyecto 'No prefijo'
	--Fecha de publicacion en el formato cast 
	--ID del proyecto

select p.id_proyecto , p.titulo ,ad.nombre_area , cp.nombre_categoria ,p.codigo ,cast( EXTRACT(MONTH FROM pp.fecha_publicacion) || '/' || EXTRACT(DAY FROM pp.fecha_publicacion) || '/' || EXTRACT(YEAR FROM pp.fecha_publicacion)
	 as varchar(500))
from proyectos p 
inner join area_departamental ad on p.id_area_responsable =ad.id_area 
inner join categorias_proyecto cp on p.id_categoria =cp.id_categoria 
inner join publicacion_proyecto pp on p.id_proyecto =pp.id_proyecto 
where p.estado ;

select * from proyectos_publicados_reformas();

DROP FUNCTION proyectos_publicados_reformas() ;
create or replace function proyectos_publicados_reformas()
returns table
(
	r_id_proyecto int, r_titulo_proyecto varchar(900), r_nombre_area varchar(900), r_nombre_categoria varchar(900), r_codigo varchar(500), r_fecha_publicacion varchar(500),r_version varchar(50), r_publicado bool
)
language 'plpgsql'
as
$BODY$
begin
	return query
	--arreglar esta funcion 
	select p.id_proyecto , p.titulo ,ad.nombre_area , cp.nombre_categoria ,p.codigo ,cast( EXTRACT(MONTH FROM y.fechapu) || '/' || EXTRACT(DAY FROM y.fechapu) || '/' || EXTRACT(YEAR FROM y.fechapu)
	 as varchar(500)),cast(TO_CHAR(p.versionp, 'FM999D0')as varchar(500)), p.publicado from 
	(select x.id as idproyecto , x.fecha as fechapu from 
	(select ROW_NUMBER() OVER (PARTITION BY pp.id_proyecto  ORDER BY pp.id_publicacion desc) AS numero_de_fila, 
	pp.id_proyecto as id, pp.versionp , pp.fecha_publicacion as fecha
	from publicacion_proyecto pp) as x
	where X.numero_de_fila =1) as Y 
	inner join proyectos p on y.idproyecto=p.id_proyecto 
	inner join area_departamental ad on p.id_area_responsable =ad.id_area 
	inner join categorias_proyecto cp on p.id_categoria =cp.id_categoria 
	where p.estado ;
end;
$BODY$


	select p.id_proyecto , p.titulo ,ad.nombre_area , cp.nombre_categoria ,p.codigo ,cast( EXTRACT(MONTH FROM pp.fecha_publicacion) || '/' || EXTRACT(DAY FROM pp.fecha_publicacion) || '/' || EXTRACT(YEAR FROM pp.fecha_publicacion)
	 as varchar(500)),cast(TO_CHAR(p.versionp, 'FM999D0')as varchar(500)), p.publicado, ROW_NUMBER() OVER (ORDER BY pp.id_proyecto) AS numero_de_fila
	from proyectos p 
	inner join area_departamental ad on p.id_area_responsable =ad.id_area 
	inner join categorias_proyecto cp on p.id_categoria =cp.id_categoria 
	inner join publicacion_proyecto pp on p.id_proyecto =pp.id_proyecto 
	where p.estado ;
	
	select p.id_proyecto , p.titulo ,ad.nombre_area , cp.nombre_categoria ,p.codigo ,cast( EXTRACT(MONTH FROM y.fechapu) || '/' || EXTRACT(DAY FROM y.fechapu) || '/' || EXTRACT(YEAR FROM y.fechapu)
	 as varchar(500)),cast(TO_CHAR(p.versionp, 'FM999D0')as varchar(500)), p.publicado from 
	(select x.id as idproyecto , x.fecha as fechapu from 
	(select ROW_NUMBER() OVER (PARTITION BY pp.id_proyecto  ORDER BY pp.id_publicacion desc) AS numero_de_fila, 
	pp.id_proyecto as id, pp.versionp , pp.fecha_publicacion as fecha
	from publicacion_proyecto pp) as x
	where X.numero_de_fila =1) as Y 
	inner join proyectos p on y.idproyecto=p.id_proyecto 
	inner join area_departamental ad on p.id_area_responsable =ad.id_area 
	inner join categorias_proyecto cp on p.id_categoria =cp.id_categoria 
	where p.estado ;


select * from proyectos;

select * from proyectos_publicados_reformas();

select * from proyectos p ;



--anadir un campo en publicacion ID_area, para saber que area fue la que elaboro dicho proyecto xdxdxd skere modo diablo 
select * from publicacion_proyecto pp ;
alter table publicacion_proyecto 
add column id_area int;

 alter table publicacion_proyecto alter column id_area set not null;

select * from proyectos p where p.id_proyecto =39;
--58
select * from area_departamental ad where ad.id_area =58;

--conectar la tabla area_departamental con el id del area de publicacion 

alter table publicacion_proyecto add constraint FK_ID_Area foreign key (id_area) references area_departamental(id_area);
update publicacion_proyecto set id_area=58 where id_publicacion =3


select * from publicacion_proyecto pp inner join area_departamental ad on pp.id_area =ad.id_area ;

--crear una tabla para la reformara de una publicacion 
--id de la reforma identity 
--id de la publicacion
-- url del documento con el alcance 
-- fecha de creacion 
--estado default true 
--id del area que realiza la reforma xdxdxd skere modo diablo 
--cuando se cree una  reforma se debe anadir al historial "se reforma el proyecto"

--creacion de la tabla de reformas 
create table reformas(
	id_reforma INT GENERATED ALWAYS AS IDENTITY,
	url_alcance varchar(900) not null ,
	fecha_creacion TIMESTAMPTZ DEFAULT Now(),
	estado bool not null,
	id_publicacion int not null,
	id_area_reforma int not null,
		Primary Key(id_reforma)
);
--conectar la tabla reformas con publicacion y con area ajajaj xd saludos 
alter table reformas add constraint FK_ID_Area foreign key (id_area_reforma) references area_departamental(id_area);
alter table reformas add constraint FK_ID_publicacion foreign key (id_publicacion) references publicacion_proyecto(id_publicacion);

select * from publicacion_proyecto pp;

--proceso almacenado para iniciar una reforma sjjsjs modo skere diablo 😈
select * from publicacion_proyecto pp ;
--id del proyecto = 39 al que se le va  a hacer la reforma 
39 -->id del proyecto para reforma 
--primero seleccionar la ultima version que esta publica de un proyecto mediante su id 
select pp.id_publicacion  from publicacion_proyecto pp where pp.id_proyecto =39 order by id_publicacion desc limit 1;
3 --> ultima publicacion de dicho proyecto 


select case when COUNT(*)>=1 then true else false end as TieneVersiones from publicacion_proyecto pp where pp.id_proyecto =39;

alter table reformas 
add column descripcion varchar(900);


 alter table reformas alter column descripcion set not null;

 alter table reformas alter column estado set  default true;

 alter table reformas alter column descripcion set default 'Alcance de la reforma';

select * from reformas r ;

--anadir el campo del codigo del proyecto a la publicacion del proyecto 
select * from publicacion_proyecto pp ;
select * from proyectos p where p.id_proyecto =39;
'CNBW6-FDCDS-REGL1-1.0'
alter table publicacion_proyecto 
add column codigo varchar(900);

 alter table publicacion_proyecto alter column codigo set not null;


update publicacion_proyecto set codigo='CNBW6-FDCDS-REGL1-1.0' where id_proyecto =39;

--en el proceso almacenado donde se publica el proyecto hay que anadir esa variable





select * from reformas r ;
select * from proyectos p where p.id_proyecto =39;


select * from publicacion_proyecto pp ;

--inicio de una reforma procedimiento almacenado 

--iniciar una reforma con el proyecto id =39
select * from proyectos p ;
--area actual 58
--area reforma 62




call iniciar_reforma(39,'URLALCANCE',62,'Descripcion del alcance');
--revertir los cambios y borrar el registro de la reforma para hacerlo esta vez con los datos faltantes y desde el frontend 
update proyectos set codigo ='CNBW6-FDCDS-REGL1-1.0',id_area_responsable =58,publicado =true where id_proyecto =39;
delete from reformas ;



Create or Replace Procedure iniciar_reforma(p_id_proyecto int,p_url_alcance varchar(900),p_id_area_reforma int,p_descripcion_alcance varchar(900))
Language 'plpgsql'
AS $$
declare 
	Tiene_Versiones bool;
	Ultima_version_publicada int;
	Prefijo_proyect varchar(50);
	Prefijo_area varchar(50);
	Prefijo_categoria varchar(50);
	Version_actual varchar(50);
	ID_Relacion  int;
	p_nombre_area varchar(900);
	p_titulo varchar (900);
Begin
	select case when COUNT(*)>=1 then true else false end as TieneVersiones into Tiene_Versiones from publicacion_proyecto pp where pp.id_proyecto =p_id_proyecto;
	if (Tiene_Versiones)
	then 
	--aqui hacer todo el proceso porque si tiene versiones anteriores publicadas 
	--primero se selecciona la ultima version publicada del proyecto 
		select pp.id_publicacion into Ultima_version_publicada from publicacion_proyecto pp where pp.id_proyecto =p_id_proyecto order by id_publicacion desc limit 1;
	--ahora si anadir todo el contenido a la tabla reforma y actualizar el proyecto
	insert into reformas(url_alcance,id_publicacion,id_area_reforma,descripcion) values (p_url_alcance,Ultima_version_publicada,p_id_area_reforma,p_descripcion_alcance);
	--tomar las variables necesarias para poder actualizar la tabla proyectos 
	--armar el codigo del proyecto 
	--create_proyect_prefij
	--lo que necesito para generar el nuevo codigo del proyecto con la version actual sin modificar 
	-- concat(new.prefijo_proyecto,'-', Pref_area,'-',Pref_cat,'-',new.versionp);
	select  p.prefijo_proyecto , cp.prefijo_categoria, p.titulo  into Prefijo_proyect,Prefijo_categoria,p_titulo
	from proyectos p 
	inner join categorias_proyecto cp on p.id_categoria =cp.id_categoria 
	where p.id_proyecto =p_id_proyecto;
	--ahora tomar el prefijo del area xdxd skere modo skere
	select ad.prefijo_departamento into Prefijo_area from area_departamental ad where ad.id_area  = p_id_area_reforma;
	--ahora tomar la ultima version segun el id de la ultima publicacion con dos decimales para formar el novo prefijo jsjsj skere modo skere skere sjere skere 
	select cast(TO_CHAR(pp.versionp, 'FM999D0')as varchar(500)) into Version_actual from publicacion_proyecto pp where pp.id_publicacion =Ultima_version_publicada;
	--ahora actualizar la tabla proyecto
	--actualizar el codigo del area, el id_area , publicado = false 
	update proyectos set codigo=concat(Prefijo_proyect,'-', Prefijo_area,'-',Prefijo_categoria,'-',Version_actual),
						id_area_responsable = p_id_area_reforma, publicado=false,reforma=true where id_proyecto =p_id_proyecto;
	--actualizar el resto de tablas que tengan que ver con el proyecto, como el historial, participantes, flujo, documentos extras, documentos proyecto -5
	update historial_proyecto set estado = false where id_proyecto = p_id_proyecto;
	update participantes set estado = false where id_proyecto = p_id_proyecto;
	update flujo_proyecto set estado = false where id_proyecto =p_id_proyecto;
	update documentos_extras set estado = false where id_proyecto =p_id_proyecto;
	update documentos_proyectos set estado = false where id_proyecto =p_id_proyecto;
	--agregar como participante del proyecto con el rol de admin al administrador de la nueva area encargada del proyecto
	--obtener el id de la realcion 
	select ua.id_relacion into ID_Relacion from usuarios_areas ua where ua.id_area =p_id_area_reforma and rol_area and estado ;
	--insertar los datos en participantes 
	insert into participantes(id_rol,id_relacion_usu_ar,id_proyecto) values(1,ID_Relacion,p_id_proyecto);
	--y agregar al historial del proyecto el mensaje sobre que se esta iniciando una reforma xdxd skere modo skere
	--obtener el nombre del area 
	select ad.nombre_area into p_nombre_area from area_departamental ad where ad.id_area  = p_id_area_reforma;
	insert into historial_proyecto (detalle,boton,tipo,id_proyecto,Descripcion, titulo)
	values (concat('El area: ',p_nombre_area, ' inició la reforma del proyecto : ',p_titulo),false,11,p_id_proyecto,'Se reforma un proyecto','Nueva reforma');
	end if;
	EXCEPTION
        -- Si ocurre un error en la transacción principal, revertir
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE EXCEPTION 'Ha ocurrido un error en la transacción principal: %', SQLERRM;
END;
$$;




--obtener el id del usuario administrador del area para ponerlo como participante del proyecto como admin tambien xd 
select ua.id_relacion  from usuarios_areas ua where ua.id_area =60 and rol_area and estado ;

--lo que necesito anadir a la tabla participantes proyecto 
--id_rol, id_relacion_usu_ar, id_proyecto
select * from participantes p ;


select * from historial_proyecto where id_proyecto =39;

select * from proyectos p ;
select * from publicacion_proyecto pp ;
select * from participantes p where p.id_proyecto = 39;

select * from documentos_extras  where id_proyecto = 39;
select * from documentos_proyectos  where id_proyecto = 39;



select * from proyectos p where p.id_proyecto =39;
--por si algo falla

--58 -->area
--CNBW6-FDCDS-REGL1-1.0 -->codigo
--3 -->publicacion
--39 --> id proyecto





select * from reformas r ;
select * from proyectos p where p.id_proyecto =39;

select * from area_departamental ad where ad.id_area =62;

select * from usuarios_areas ua where ua.id_area =62;



select cast(TO_CHAR(pp.versionp, 'FM999D0')as varchar(500)) from publicacion_proyecto pp where pp.id_publicacion =3;

select  p.prefijo_proyecto , cp.prefijo_categoria 
from proyectos p 
inner join categorias_proyecto cp on p.id_categoria =cp.id_categoria 
where p.id_proyecto =35;

select ad.prefijo_departamento from area_departamental ad where ad.id_area  = 60;

select * from usuario u  order by nombres asc;
declare numeros_registros = 10,20,30,40;



--funcion que retorne todas las areas que administra un usuario segun su id 
--c09cda3f-0346-4243-8e59-82d8741e32b1
--id del area y el nombre solamente con eso basta
--nombrearea
--area_id



select ad.id_area ,ad.nombre_area  
from usuarios_areas ua 
inner join area_departamental ad ON ua.id_area =ad.id_area 
where cast(ua.id_usuario as varchar(900))= 'c09cda3f-0346-4243-8e59-82d8741e32b1' and ua.estado and ua.rol_area ;


select * from areas_que_administra('c09cda3f-0346-4243-8e59-82d8741e32b1' );

--ESTA FUNCION SIRVE PARA LISTAR LAS AREAS QUE ADMINISTRA UN USUARIO SEGUN SU ID DE USARIO PARA PODER LISTARLAS PARA LAS REFORMAS 
create or replace function areas_que_administra(idu varchar(900))
returns table
(
	area_id int,nombrearea varchar(800)
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select ad.id_area ,ad.nombre_area  
	from usuarios_areas ua 
	inner join area_departamental ad ON ua.id_area =ad.id_area 
	where cast(ua.id_usuario as varchar(900))= idu and ua.estado and ua.rol_area ;
end;
$BODY$





select * from publicacion_proyecto pp ;
select * from reformas r ;

select * from proyectos p ;
--anadir un campo que diga reforma en la tabla proyecto que sea false hasta que se publique porque a partir de alli se hace true porque se hace una reforma	
alter table proyectos 
add column reforma bool;

 alter table proyectos alter column reforma set default false;

update proyectos set reforma=true where id_proyecto =37 ;



select * from publicacion_proyecto pp ;
select * from proyectos p where p.id_proyecto =39;


--funcion para retornar si el proyecto es reforma o no para poder mostrar las opciones de ver el alcance y ver las versiones anteriores
select p.reforma  from proyectos p where p.id_proyecto = 39;

select * from proyecto_es_reforma(39);
create or replace function proyecto_es_reforma(proyecto_id int)
returns table
(
	r_reforma bool
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select p.reforma  from proyectos p where p.id_proyecto = proyecto_id;
end;
$BODY$


select * from tipos_jerarquia tj ;

select * from publicacion_proyecto pp ;


--parte de John para poder hacer el paguinator 
CREATE OR REPLACE FUNCTION public.users_paginacion(
	numero_pagina integer default 1)
    RETURNS TABLE(userid character varying, nombres_user character varying, tip_iden character varying, identi character varying, correo_personal_user character varying, correo_institucional_user character varying, numero_celular_user character varying, estado_user boolean, url_foto_user character varying, nombre_firma_user character varying, isadmin_user boolean, estadou character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

begin
	IF numero_pagina IS NULL OR numero_pagina <= 0 THEN
        numero_pagina := 1;
    END IF;
	
		return query
		SELECT
			cast(id_user as varchar(500)) as UsuarioID,nombres,tipo_identificacion,identificacion,correo_personal,correo_institucional,numero_celular,estado,url_foto,nombre_firma,isadmin,
			cast (case when estado then 'Habilitado' else 'Deshabilitado' end as varchar(50)) as estado_descripcion
		FROM usuario
		ORDER BY nombres -- Ordenar por nombres para obtener resultados en orden alfabético
		LIMIT 5 -- Número de filas por página
		OFFSET ((numero_pagina  - 1) * 5); -- Calcular el desplazamiento en función de la página seleccionada
end;
$BODY$;

CREATE OR REPLACE FUNCTION public.users_total_paginacion()
    RETURNS TABLE(r_total_paginas numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
    numero_pagina numeric default 5;
begin
	return query
	SELECT CEIL(COUNT(*)::numeric / numero_pagina) as total_paginas
	FROM usuario;
end;
$BODY$;

select * from publicacion_proyecto pp2 ;
select pp.id_publicacion ,pp.versionp  from publicacion_proyecto pp where pp.id_proyecto = 37;

select pp.url_doc  from publicacion_proyecto pp where pp.id_publicacion =4;

---ver las versiones de los proyecto 



--------funcion para mostra las versiones segun id del proyecto---------
-- DROP FUNCTION IF EXISTS public.list_combobox_version(integer );

CREATE OR REPLACE FUNCTION public.list_combobox_version(
	id_proyecto_i integer )
    RETURNS TABLE(r_id_publicacion integer, r_version_p numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
	return query
	select pp.id_publicacion, pp.versionp from publicacion_proyecto pp where pp.id_proyecto= id_proyecto_i;
end;
$BODY$;

--select * from list_combobox_version(37)


-----------funcion que retorna la url del documento seleccinado-----------

-- DROP FUNCTION IF EXISTS public.Ver_Documento_version(integer );

CREATE OR REPLACE FUNCTION public.ver_documento_version(
	id_publi_version integer )
    RETURNS TABLE(r_url_doc character varying(900)) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
	return query
	select pp.url_doc from publicacion_proyecto pp where pp.id_publicacion = id_publi_version;
end;
$BODY$;

--select * from Ver_Documento_version(4);

select * from proyectos p ;
select * from reformas r ;

select * from usuario u ;

select * from usuarios_areas ua where ua.id_usuario ='2cffc463-0a2d-4e4a-982a-88c89d1f6a53';


delete from usuario where id_user ='4f8c8d6f-4ab3-41cc-9216-fcb6407efdbb';
delete from usuarios_areas where id_usuario  ='4f8c8d6f-4ab3-41cc-9216-fcb6407efdbb';




--ROLES USUARIOS DE UN PROYECTO : JOHN

-------funcion para sacar los datos del documento de alcance segun el proyecto, solo los que son reforma----------
/*
select url_alcance, cast(to_char(r.fecha_creacion,'DD-MON-YYYY')as varchar(500)),r.id_reforma, r.descripcion 
	from reformas r inner join publicacion_proyecto pp on r.id_publicacion = pp.id_publicacion
	where pp.id_proyecto = 40 and pp.estado =true and r.estado = true
	order by  r.id_reforma desc limit 1;
*/
--id 40 proyecto

create OR REPLACE FUNCTION public.ver_docs_alcance(p_id_proyecto integer)
 RETURNS TABLE(d_url character varying, d_fecha character varying, d_id integer, d_descripcion character varying)
 LANGUAGE plpgsql
AS $function$
begin
	return query
	select url_alcance, cast(to_char(r.fecha_creacion,'DD-MON-YYYY')as varchar(500)),r.id_reforma, r.descripcion 
	from reformas r inner join publicacion_proyecto pp on r.id_publicacion = pp.id_publicacion
	where pp.id_proyecto = p_id_proyecto and pp.estado =true and r.estado = true
	order by  r.id_reforma desc limit 1;

end;
$function$
;	

----funcion para mostra el pdf del alcance de la reforma-------------

create OR REPLACE FUNCTION public.ver_pdf_alcance(p_id_reforma integer)
 RETURNS TABLE(d_url character varying)
 LANGUAGE plpgsql
AS $function$
begin
	return query
	select url_alcance
	from reformas r
	where r.id_reforma = p_id_reforma and r.estado = true;

end;
$function$
;	
/*
	select url_alcance
	from reformas r
	where r.id_reforma = 6 and r.estado = true;
*/

select * from proyectos p where id_proyecto =40

---Modificar la funcion rol_proyecto para mandar si el proyecto es reforma--------

--drop function if exists public.rol_proyecto(character varying, integer);
--42
select * from rol_proyecto('e251e875-9614-4737-b176-031b7c0b1183',42);

CREATE OR replace FUNCTION public.rol_proyecto(p_idu character varying, p_id_proyecto integer)
 RETURNS TABLE(p_titulo character varying, p_rol character varying, p_subir boolean,p_reforma boolean, p_codigo  character varying, p_flujo boolean)
 LANGUAGE plpgsql
AS $function$
begin
	return query
	select * from
	(select p.titulo,case when ua.rol_area then cast('Admin' as varchar(100)) else cast('Not admin' as varchar(100)) end ,p.subir_docs,p.reforma ,p.codigo 
	from proyectos p 
	inner join area_departamental ad on p.id_area_responsable =ad.id_area 
	inner join usuarios_areas ua on ad.id_area =ua.id_area 
		where cast(ua.id_usuario as varchar(500))=p_idu and p.id_proyecto=p_id_proyecto) as x inner join
	(select case when COUNT(*)>0 then true else false end as TieneFLujo from flujo_proyecto fp 
	where id_proyecto = p_id_proyecto and estado =true ) as y on 1=1;
end;
$function$
;

--funcion para ver los datos del proyecto en revision o publicacion
titulo, rol, reforma, p codigo, p_activar firmas
select * from 
participantes p 
inner join usuarios_areas ua ON p.id_relacion_usu_ar =ua.id_relacion 
inner join proyectos p2 on p.id_proyecto =p2.id_proyecto 
inner join roles r on p.id_rol =r.id_rol 
where ua.id_usuario ='e251e875-9614-4737-b176-031b7c0b1183' 
and p2.id_proyecto  =42;



select * from proyectos p ;
/*
select * from
	(select p.titulo,case when ua.rol_area then cast('Admin' as varchar(100)) else cast('Not admin' as varchar(100)) end ,p.subir_docs, p.reforma 
	from proyectos p 
	inner join area_departamental ad on p.id_area_responsable =ad.id_area 
	inner join usuarios_areas ua on ad.id_area =ua.id_area 
		where cast(ua.id_usuario as varchar(500))= 'c09cda3f-0346-4243-8e59-82d8741e32b1' and p.id_proyecto=40) as x inner join
	(select case when COUNT(*)>0 then true else false end as TieneFLujo from flujo_proyecto fp 
	where id_proyecto = 40 and estado =true ) as y on 1=1;
*/

------------funcion para que mande el rol que es el usario en ese proyecto------

CREATE OR REPLACE FUNCTION public.user_data_rol(idu character varying,p_id_proyecto integer,p_id_area integer)
 RETURNS TABLE(nombres_user character varying, correo_institucional_user character varying, rol_user character varying)
 LANGUAGE plpgsql
AS $function$
begin
	return query
	select u.nombres, u.correo_institucional, r.rol 
	from usuario u 
	inner join usuarios_areas ua on u.id_user = ua.id_usuario
	inner join participantes p on ua.id_relacion = p.id_relacion_usu_ar
	inner join roles r on p.id_rol =r.id_rol
	where ua.id_area =  p_id_area and u.estado = true and ua.estado = true and p.estado = true and r.estado = true and
	cast(id_user as varchar(500))= idu and p.id_proyecto = p_id_proyecto;
end;
$function$
;

--funcion que retorne el  nombre del area y el prefijo del area para poderlos editar xdxd skere modo diablo
select ad,id_area ,ad.nombre_area , ad.prefijo_departamento  from area_departamental ad ;
create or replace function datos_editar_area(idu int)
returns table
(
	r_nombre_area varchar(800), r_prefijo_area varchar(10)
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select ad.nombre_area , ad.prefijo_departamento  from area_departamental ad where ad.id_area =idu;
end;
$BODY$

select * from datos_editar_area(60);


--procedimiento almacenado para cambiar los datos de un proyecto como por ejemplo: el titulo y el prefijo, al cambiarlos se debe actualizar el encabezado 
--hacer que un proyecto se lo puede deshabilitar, cualquier area lo puede deschabilitar para no poderlo enlistar para reformas pero si para verlo publicamente
--hacer que un proyecto se lo pueda poner publico o no xd skere modo setzo
select * from proyectos p ;

--anadir un campo a la tabla proyectos que indique si un proyecto puede ser publico o se va mantener bajo sistema
alter table proyectos 
add column publico bool;

update proyectos set publico = true;
alter table proyectos  alter column publico set default true;
alter table proyectos alter column publico set not null;

--aqui empieza el procedimiento almacenado para editar los datos de un proyecto como el titulo, prefijo y si es o no publico
--primero obtener la version actual, el prefijo del departamento, el prefijo de la categoria  

--concat(Prefijo_proyect,'-', Prefijo_area,'-',Prefijo_categoria,'-',Version_actual)
--por ejemplo el id del proyecto 35

select cp.prefijo_categoria  from proyectos p inner join categorias_proyecto cp on p.id_categoria =cp.id_categoria where p.id_proyecto =35;
select ad.prefijo_departamento  from proyectos p inner join area_departamental ad on p.id_area_responsable =ad.id_area where p.id_proyecto =35;
select p.versionp  from proyectos p where p.id_proyecto =35;
select TO_CHAR(p.versionp, 'FM999D0') from proyectos p where p.id_proyecto =35;

select * from proyectos p ;


--inicio el procedimiento 
Create or Replace Procedure editar_proyecto_datos(p_titulo varchar(900),
										p_prefijo_nuevo varchar(50), p_id_proyecto int, p_visibilidad bool)
Language 'plpgsql'
AS $$
declare 
	p_prefijo_categoria varchar(50);
	p_prefijo_area varchar(50);
	p_version_actual varchar(50);
	p_codigo_actual varchar(900);
	p_prefijo_actual varchar(50);
	p_titulo_actual varchar(900);
Begin
	--primero verificar que lo que venga no es nullo xdxdxd skere
		if trim(p_titulo)='' then
			raise exception 'Titulo no puede ser vacio';
		end if;
		if trim(p_prefijo_nuevo)='' then
			raise exception 'El prefijo no puede ser vacio';
		end if;
		if length(p_prefijo_nuevo)<>5 then
					raise exception 'El prefijo requiere 5 digitos';
		end if;
		--si no hay errores entonces obtener los prefijos actuales xd skere 
	--primero el prefijo de la categoria 
	select cp.prefijo_categoria into p_prefijo_categoria from proyectos p inner join categorias_proyecto cp on p.id_categoria =cp.id_categoria where p.id_proyecto =p_id_proyecto;
	select ad.prefijo_departamento into p_prefijo_area from proyectos p inner join area_departamental ad on p.id_area_responsable =ad.id_area where p.id_proyecto =p_id_proyecto;
	select TO_CHAR(p.versionp, 'FM999D0'),p.codigo ,p.prefijo_proyecto,p.titulo 
	into p_version_actual,p_codigo_actual,p_prefijo_actual, p_titulo_actual
	from proyectos p where p.id_proyecto =p_id_proyecto;
	--hacer el update 
	update proyectos set codigo =concat(p_prefijo_nuevo,'-', p_prefijo_area,'-',p_prefijo_categoria,'-',p_version_actual), titulo =p_titulo, prefijo_proyecto =p_prefijo_nuevo, publico=p_visibilidad
	where id_proyecto =p_id_proyecto;
	--tambien agregar al historial del proyecto todos los cambios realizados como el cambio de prefijo, titulo y del codigo para la trazabilidad
	insert into historial_proyecto (detalle,boton,tipo,id_proyecto,Descripcion, titulo)
	values (concat('Se cambio el titulo del proyecto por : ',p_titulo),false,12,p_id_proyecto,'Se cambia el titulo del proyecto','Cambio de titulo');
	--insertar en el historial el cambio de prefijo xd 
	insert into historial_proyecto (detalle,boton,tipo,id_proyecto,Descripcion, titulo)
	values (concat('Se cambio el prefijo del proyecto por : ',p_prefijo_actual),false,12,p_id_proyecto,'Se cambia el prefijo del proyecto','Cambio de prefijo');
COMMIT;
END;
$$;

select * from proyectos p where p.id_proyecto =35;
	insert into historial_proyecto (detalle,boton,tipo,id_proyecto,Descripcion, titulo)
	values (concat('Se cambio el nombre del proyecto por : ',p_nombre_area, ' creó el proyecto : ',p_titulo),false,12,p_id_proyecto,'Se crea un proyecto','Creación del proyecto');

select distinct(hp.tipo) from historial_proyecto hp order by hp.tipo asc;
--funcion que retorne los datos que se van a editar del proyecto como el titulo, prefijo y su visibilidad
create or replace function datos_a_editar_proyecto(p_id_proyecto int)
returns table
(
	r_titulo varchar(800), r_prefijo varchar(50), r_publico bool
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select p.titulo ,p.prefijo_proyecto ,p.publico from proyectos p where p.id_proyecto =p_id_proyecto;
end;
$BODY$

select * from datos_a_editar_proyecto(35);

select * from proyectos p ;


select * from documentos_proyectos dp ;



---John modificado para listar usuarios segun el proyecto para el que participan 
-------modificar funcion para lista los proyecto en los que esta el usario--------------

--drop function if exists public.proyectos_areas(integer, boolean,character varying);

CREATE OR REPLACE FUNCTION public.proyectos_areas(p_id_area integer, p_is_admin boolean, p_id_user character varying)
 RETURNS TABLE(p_id_proyecto integer, p_titulo character varying, p_codigo character varying, 
 p_estado boolean, p_prefijo character varying, p_categoria character varying, p_subir boolean, 
 p_titulo_nivel character varying, p_tipo_nivel integer, p_reforma boolean)
 LANGUAGE plpgsql
AS $function$
begin
	--Muestra todos los proyectos si es admin
	if(p_is_admin)then 
		return query
		select DISTINCT  * from 
		(
		select p.id_proyecto,p.titulo, p.codigo, p.estado,p.prefijo_proyecto, cp.nombre_categoria ,p.subir_docs,cast('Elaboracion'as varchar(500)),cast(1 as int), p.reforma
		from proyectos p inner join categorias_proyecto cp on p.id_categoria=cp.id_categoria
		where p.id_area_responsable = p_id_area and  p.publicado = false
		union ALL
		select p.id_proyecto,p.titulo, p.codigo, p.estado,p.prefijo_proyecto, cp.nombre_categoria, p.subir_docs, n.titulo,n.tipo_nivel, p.reforma
		from niveles_proyecto np 
		inner join estado_nivel en on np.id_niveles_pro =en.id_nivel 
		inner join flujo_proyecto fp on np.id_flujo = fp.id_flujo 
		inner join proyectos p on fp.id_proyecto =p.id_proyecto 
		inner join niveles n on np.id_nivel =n.id_nivel 
		inner join categorias_proyecto cp on p.id_categoria =cp.id_categoria 
		where np.id_departamento = p_id_area and np.estado =true and en.estado =true and en.enviando = false and p.publicado = false and p.estado = true
		) as x order by x.titulo asc;	
	else 
		return query
		
		--- si no es admin entonces muestra los proyecto solo si el usario pertenece a estos
		select distinct * from 
		(
			select p.id_proyecto,p.titulo, p.codigo, p.estado,p.prefijo_proyecto, cp.nombre_categoria ,p.subir_docs,cast('Elaboracion'as varchar(500)),cast(1 as int), p.reforma
			from proyectos p inner join categorias_proyecto cp on p.id_categoria=cp.id_categoria
			inner join participantes p2 on p.id_proyecto = p2.id_proyecto
			inner join usuarios_areas ua on p2.id_relacion_usu_ar = ua.id_relacion 
			where p.id_area_responsable = p_id_area and p.publicado = false and p2.estado = true
			and p.estado = true and ua.estado = true 
			and cast(ua.id_usuario as varchar(500)) = p_id_user
			
		union ALL
			select p.id_proyecto,p.titulo, p.codigo, p.estado,p.prefijo_proyecto, cp.nombre_categoria, p.subir_docs, n.titulo,n.tipo_nivel, p.reforma
			from niveles_proyecto np 
			inner join estado_nivel en on np.id_niveles_pro =en.id_nivel 
			inner join flujo_proyecto fp on np.id_flujo = fp.id_flujo 
			inner join proyectos p on fp.id_proyecto =p.id_proyecto
			inner join participantes p2 on p.id_proyecto = p2.id_proyecto
			inner join usuarios_areas ua on p2.id_relacion_usu_ar = ua.id_relacion 
			inner join niveles n on np.id_nivel =n.id_nivel 
			inner join categorias_proyecto cp on p.id_categoria =cp.id_categoria 
			where np.id_departamento = p_id_area and np.estado =true and en.estado =true 
			and en.enviando = false and p.publicado = false and p.estado = true
			and p2.estado = true
			and ua.estado = true
			and cast(ua.id_usuario as varchar(500)) = p_id_user	
		)
		as x order by x.titulo asc;
		
	end if;
end;
$function$
;

--cast(id_user as varchar(500))
--area 61
--id user '5ad3fa95-293d-4cba-91d0-1c973aea0810'
--select * from proyectos_areas(61,false,'5ad3fa95-293d-4cba-91d0-1c973aea0810')

select p.id_proyecto,p.titulo, p.codigo, p.estado,p.prefijo_proyecto, cp.nombre_categoria ,p.subir_docs,cast('Elaboracion'as varchar(500)),cast(1 as int), cast(0 as int), p.reforma
		from proyectos p inner join categorias_proyecto cp on p.id_categoria=cp.id_categoria
		where p.id_area_responsable = 61 and p.publicado = false;
		
		
------------------------------------------------------------
	
	
	
--anadir un campo para saber si el documento del proyecto esta preparado es decir esta todo adjuntando para poder publicarlo
	alter table proyectos 
add column documento_preparado bool;

update proyectos set documento_preparado = false ;
alter table proyectos  alter column documento_preparado set default false;
alter table proyectos alter column documento_preparado set not null;




titulo, rol, reforma, p codigo, p_documento_preparado
select p2.titulo , r.rol ,p2.reforma ,p2.codigo ,p2.documento_preparado from 
participantes p 
inner join usuarios_areas ua ON p.id_relacion_usu_ar =ua.id_relacion 
inner join proyectos p2 on p.id_proyecto =p2.id_proyecto 
inner join roles r on p.id_rol =r.id_rol 
where cast(ua.id_usuario as character varying) ='e251e875-9614-4737-b176-031b7c0b1183' 
and p2.id_proyecto  =42;


select * from datos_revision('e251e875-9614-4737-b176-031b7c0b1183',42);

create or replace function datos_revision(idu varchar(900),p_id_proyecto int )
returns table
(
	r_titulo varchar(800), r_rol_user  varchar(800), r_reforma bool, r_codigo  varchar(800), r_documento_preparado bool
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select p2.titulo , r.rol ,p2.reforma ,p2.codigo ,p2.documento_preparado from 
	participantes p 
	inner join usuarios_areas ua ON p.id_relacion_usu_ar =ua.id_relacion 
	inner join proyectos p2 on p.id_proyecto =p2.id_proyecto 
	inner join roles r on p.id_rol =r.id_rol 
	where cast(ua.id_usuario as character varying) =idu and p.estado =true 
	and p2.id_proyecto  =p_id_proyecto;
end;
$BODY$


	select p2.titulo , r.rol ,p2.reforma ,p2.codigo ,p2.documento_preparado from 
	participantes p 
	inner join usuarios_areas ua ON p.id_relacion_usu_ar =ua.id_relacion 
	inner join proyectos p2 on p.id_proyecto =p2.id_proyecto 
	inner join roles r on p.id_rol =r.id_rol 
	where cast(ua.id_usuario as character varying) ='e251e875-9614-4737-b176-031b7c0b1183' and p.estado =true 
	and p2.id_proyecto  =42;





--en la tabla proyecto hay que hacer que solo aparescan solo dos botones 
--si recien llega a publicacion = preparar =(esto serviria para adjuntar todos los documentos y habilitar las firmas )
--								  rechazar =(este boton siempre debe mostrarse skere modo diablo)
--								  publicar = (este boton se debe mostrar si el documento ya estuvo preparado)

select * from proyectos p;


--solo van completos los de elaboracion y los admins de areas de revision
--el documento no se puede publicar hasta que no esten todas las firmas completas 
--hacer la opcion de firmar documentos xd skere modo diablo

create table area_departamental(
	Id_area INT GENERATED ALWAYS AS IDENTITY,
	nombre_area varchar(200) not null ,
	fecha_creacion TIMESTAMPTZ DEFAULT Now(),
	estado bool not null,
	id_nivel int not null,
	logo_url varchar(500) not null,
		Primary Key(Id_area)
);
---crear una tabla para las firmas 
--se tiene que concectar la tabla us

--creacion de la tabla firma 
create table Firma_proyecto (
	ID_Firma inT generated always As identity,
	fecha_creacion timestamptz default now(),
	estado bool not null default true,
	ID_proyecto int not null,
			Primary Key(ID_Firma)
);

--creacion de tabla detalle firma o firmas participantes 
create table Firma_participantes (
	ID_Firma_participantes int generated always as identity,
	fecha_creacion timestamptz default now(),
	estado bool not null default true,
	fecha_firma date,
	ID_Firma int not null,
	firmado bool not null default false,
	Id_usuario uuid,
		primary key (ID_Firma_participantes)
);

--agregar las referencias foreing key 
--primero la tabla firma_proyecto a proyecto 
select id_user  from usuario ;
select p.id_proyecto  from proyectos p ;
alter table Firma_proyecto add constraint FK_Firma_Proyecto FOREIGN KEY (ID_proyecto) references proyectos(id_proyecto);
--ahora la tabla firma participantes a firma proyecto 
alter table Firma_participantes add constraint FK_Participantes_firma FOREIGN KEY (ID_Firma) references Firma_proyecto(ID_Firma);
--ahora la tabla firma particitpantes con usuarios 
alter table Firma_participantes add constraint FK_Participantes_usuarios FOREIGN KEY (Id_usuario) references usuario(id_user);



select * from empresa e ;






--esta consulta debe recorrer el cursor para obtener el id del usuario y agregarlo a la tabla de firmas de proyecto xd 
select  u.id_user , u.nombre_firma, n.titulo 
	from participantes p 
	inner join proyectos p2 on p2.id_proyecto =p.id_proyecto 
	inner join flujo_proyecto fp on p2.id_proyecto = fp.id_proyecto 
	inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
	inner join usuarios_areas ua on p.id_relacion_usu_ar = ua.id_relacion 
	inner join niveles n on np.id_nivel =n.id_nivel 
	inner join usuario u on ua.id_usuario =u.id_user 
	inner join area_departamental ad on ua.id_area = ad.id_area 
	where p.id_proyecto =42 and fp.estado and np.id_departamento =ua.id_area and p.estado and (n.tipo_nivel =1 or (n.tipo_nivel =2 and p.id_rol=1)or (n.tipo_nivel =3 and p.id_rol=1))
 	order by n.tipo_nivel asc ;

 
 
 
 
 --listar los proyecto que necesitan la firma de un usuario segun su id de usuario skere modo diablo skere modo diablo skere modo diablo


--crear la funcion 
create or replace function documentos_por_firmar(idu varchar(500))
returns table
(
	r_id_proyecto int, r_titulo_proyecto varchar(800), r_codigo_proyecto varchar(800), r_categoria_proyecto varchar(800), r_id_area int, r_nombre_area varchar(800), r_id_firma_participantes int, r_id_firma int
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select p.id_proyecto , p.titulo ,p.codigo ,cp.nombre_categoria, ad.id_area , ad.nombre_area, fp.id_firma_participantes , fp2.id_firma  from 
	firma_participantes fp 
	inner join firma_proyecto fp2 on fp.id_firma =fp2.id_firma 
	inner join proyectos p on p.id_proyecto =fp2.id_proyecto 
	inner join area_departamental ad on p.id_area_responsable =ad.id_area 
	inner join categorias_proyecto cp on p.id_categoria =cp.id_categoria 
	where cast(fp.id_usuario as varchar(900))=idu and fp.estado and fp2.estado  and  fp.firmado = false  ;
	end;
$BODY$


select * from usuario u where u.correo_institucional ='rcoelloc2@uteq.edu.ec'
select * from documentos_por_firmar('c09cda3f-0346-4243-8e59-82d8741e32b1');

select url_foto  from usuario where cast(id_user as varchar(500))=idu;


--funcion que retornar todos los participantes que tienen que firmar mas su estado xd skere modo diablo


--funcion que calcule la posicion en Y, y la paguina en donde tiene que firmar el participante segun su id y el id del proyecto 
--ejemplo con modelo educativo
	select  u.id_user , u.nombre_firma, n.titulo , n.tipo_nivel 
	from participantes p 
	inner join proyectos p2 on p2.id_proyecto =p.id_proyecto 
	inner join flujo_proyecto fp on p2.id_proyecto = fp.id_proyecto 
	inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
	inner join usuarios_areas ua on p.id_relacion_usu_ar = ua.id_relacion 
	inner join niveles n on np.id_nivel =n.id_nivel 
	inner join usuario u on ua.id_usuario =u.id_user 
	inner join area_departamental ad on ua.id_area = ad.id_area 
	where p.id_proyecto =42 and fp.estado and np.id_departamento =ua.id_area and p.estado and (n.tipo_nivel =1 or (n.tipo_nivel =2 and p.id_rol=1)or (n.tipo_nivel =3 and p.id_rol=1))
 	order by n.tipo_nivel asc ;
 
 
 --consulta que retorne la lista de usuarios 
SELECT
    cast(u.id_user as varchar(900)),
    u.nombre_firma,
    n.titulo,
    n.tipo_nivel,
    ROW_NUMBER() OVER(PARTITION BY n.tipo_nivel ORDER BY n.tipo_nivel ASC) AS numero_de_fila
FROM
    participantes p
    INNER JOIN proyectos p2 ON p2.id_proyecto = p.id_proyecto
    INNER JOIN flujo_proyecto fp ON p2.id_proyecto = fp.id_proyecto
    INNER JOIN niveles_proyecto np ON fp.id_flujo = np.id_flujo
    INNER JOIN usuarios_areas ua ON p.id_relacion_usu_ar = ua.id_relacion
    INNER JOIN niveles n ON np.id_nivel = n.id_nivel
    INNER JOIN usuario u ON ua.id_usuario = u.id_user
    INNER JOIN area_departamental ad ON ua.id_area = ad.id_area
WHERE
    p.id_proyecto = 42
    AND fp.estado
    AND np.id_departamento = ua.id_area
    AND p.estado
    AND (n.tipo_nivel = 1 OR (n.tipo_nivel = 2 AND p.id_rol = 1) OR (n.tipo_nivel = 3 AND p.id_rol = 1))
ORDER BY
    n.tipo_nivel ASC;

   
 --funcion que retorne el listado de usuarios para calcular su posiciion en la firma xdxdxs skere modo diablo skere skere skere
   DROP FUNCTION listado_para_firmar(integer);
   create or replace function listado_para_firmar(p_id_proyecto int)
returns table
(
	r_id_user varchar(800), r_nombre_firma varchar(900), r_titulo_nivel varchar(900), r_tipo_nivel int, r_numero_fila int
)
language 'plpgsql'
as
$BODY$
begin
	return query
	SELECT
    cast(u.id_user as varchar(900)),
    u.nombre_firma,
    n.titulo,
    n.tipo_nivel,
    cast(ROW_NUMBER() OVER(PARTITION BY n.tipo_nivel ORDER BY n.tipo_nivel ASC)as int) AS numero_de_fila
FROM
    participantes p
    INNER JOIN proyectos p2 ON p2.id_proyecto = p.id_proyecto
    INNER JOIN flujo_proyecto fp ON p2.id_proyecto = fp.id_proyecto
    INNER JOIN niveles_proyecto np ON fp.id_flujo = np.id_flujo
    INNER JOIN usuarios_areas ua ON p.id_relacion_usu_ar = ua.id_relacion
    INNER JOIN niveles n ON np.id_nivel = n.id_nivel
    INNER JOIN usuario u ON ua.id_usuario = u.id_user
    INNER JOIN area_departamental ad ON ua.id_area = ad.id_area
WHERE
    p.id_proyecto = p_id_proyecto
    AND fp.estado
    AND np.id_departamento = ua.id_area
    AND p.estado
    AND (n.tipo_nivel = 1 OR (n.tipo_nivel = 2 AND p.id_rol = 1) OR (n.tipo_nivel = 3 AND p.id_rol = 1))
ORDER BY
    n.tipo_nivel ASC;
end;
$BODY$


select * from listado_para_firmar(42);



--funcion que retorne la lista de usuario que estan firmado el documento, ver su estado de firma , poder actualizar o habilitar su firma 
select u.nombres ,u.correo_institucional ,u.correo_personal ,u.numero_celular ,u.identificacion ,fp.firmado ,fp.estado ,fp.fecha_firma  
from firma_participantes fp 
inner join firma_proyecto fp2 on fp.id_firma =fp2.id_firma 
inner join usuario u on fp.id_usuario = u.id_user 
where fp2.id_proyecto =42
;


select * from usuarios_por_firmar(42);

DROP FUNCTION usuarios_por_firmar(integer);
create or replace function usuarios_por_firmar(p_id_proyecto int)
returns table
(
	r_id_firma int ,r_nombres_usuario varchar(800), r_correo_institucional varchar(800), r_correo_personal varchar(800), r_numero_celular varchar(800), r_identificacion varchar(800), r_firmado bool, r_estado bool, r_fecha_firma varchar(800), r_id_user varchar(800)
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select fp.id_firma_participantes ,u.nombres ,u.correo_institucional ,u.correo_personal ,u.numero_celular ,u.identificacion ,fp.firmado ,fp.estado ,cast( EXTRACT(MONTH FROM fp.fecha_firma  ) || '/' || EXTRACT(DAY FROM fp.fecha_firma  ) || '/' || EXTRACT(YEAR FROM fp.fecha_firma  )
	 as varchar(500)), cast(u.id_user  as varchar(500) )
	from firma_participantes fp 
	inner join firma_proyecto fp2 on fp.id_firma =fp2.id_firma 
	inner join usuario u on fp.id_usuario = u.id_user 
	where fp2.id_proyecto =p_id_proyecto and fp2.estado ;
end;
$BODY$

select * from firma_participantes fp ;

--fp.fecha_firma  



--funcion de prueba xd 
Create or Replace Procedure Estado_Categoria(
										   p_id_cate varchar(100)
										 )
Language 'plpgsql'
AS $$
declare 
	Estado_old bool;
Begin
--update area_departamental  set cabezera = false where id_area = 11;
	select into Estado_old not estado from categorias_proyecto where  id_categoria=cast(p_id_cate as int) ;
		update categorias_proyecto set estado  = Estado_old
		where  id_categoria = cast(p_id_cate as int);
COMMIT;
END;
$$;

--procedimiento almacenado para cambiar el estado de firma de un usuario mediante el id de firma xdxd skere modo diablo 
select fp.estado  from firma_participantes fp where fp.id_firma_participantes =4;

Create or Replace Procedure cambiar_estado_firma(
										   id_firma_participante int
										 )
Language 'plpgsql'
AS $$
Begin
		update firma_participantes set estado  = not estado
		where  id_firma_participantes = id_firma_participante;
COMMIT;
END;
$$;

call cambiar_estado_firma(3);
select * from firma_participantes fp ;


--funcion para saber si todos los particpantes han firmado el documento para poderlo publicar skere modo diablo
select case when count(*) = (select count(*)
							from firma_participantes fp 
							inner join firma_proyecto fp2 on fp.id_firma =fp2.id_firma 
							where fp2.id_proyecto =42) 
then true else false end as Verificar
from firma_participantes fp 
inner join firma_proyecto fp2 on fp.id_firma =fp2.id_firma 
where fp2.id_proyecto =42 and fp.firmado ;


update firma_participantes set  firmado=false  ;


--funcion para saber si un proyecto tiene todas sus firmas completas 

select * from verificar_firmas_usuarios(42);

create or replace function verificar_firmas_usuarios(p_id_proyecto int)
returns table
(
	r_verificador bool
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select case when count(*) = (select count(*)
							from firma_participantes fp 
							inner join firma_proyecto fp2 on fp.id_firma =fp2.id_firma 
							where fp2.id_proyecto =p_id_proyecto) 
	then true else false end as Verificar
	from firma_participantes fp 
	inner join firma_proyecto fp2 on fp.id_firma =fp2.id_firma 
	where fp2.id_proyecto =p_id_proyecto and fp.firmado and fp2.estado  ;
end;
$BODY$




--procedimiento almacenado para modificar el documento con la nueva firma insertada 
--tambien para registrar que el usuario ya firmo 
--de aqui obtener el id que se necesita para modificar el pdf skere modo diablo
--de aqui obtener el id de id_firma_participantes a editar para cambiar el firmado a true e insertar la fecha actual
select * from 
firma_participantes fp 
inner join firma_proyecto fp2 on fp.id_firma =fp2.id_firma  
where fp2.id_proyecto =42 and fp2.estado and cast(fp.id_usuario as varchar(900))='687baac7-a954-4d24-9bc2-ae78d90df2ed' ;


select * from usuario u ;
select * from documentos_proyectos dp where dp.id_proyecto =42 and dp.estado ;
--select * from Now();

Create or Replace Procedure firmar_documento_proyecto(p_url varchar(900),
										   p_id_proyecto int,
										   p_id_user varchar(900)
										   )
Language 'plpgsql'
AS $$
declare
	p_id_documento int;
	p_id_firma int;
	p_nombres_usuario varchar(800);
begin
	--verificar si el archivo que se esta enviando no es undefined 
	if (p_url = '../../uploads/proyectos/undefined') then
		raise exception 'Suba un archivo valido';
	end if; 
	--obtener el id del registro para modificarlo por el nuevo que tiene la firma 
	select dp.id_documento into p_id_documento from documentos_proyectos dp where dp.id_proyecto =p_id_proyecto and dp.estado ;
	--obtener el id del registro de la firma
	select fp.id_firma_participantes into p_id_firma from 
	firma_participantes fp 
	inner join firma_proyecto fp2 on fp.id_firma =fp2.id_firma  
	where fp2.id_proyecto =p_id_proyecto and fp2.estado and cast(fp.id_usuario as varchar(900))=p_id_user ;
	--actualizar el ultimo documento de la url_modificado 
	update documentos_proyectos set url_modificado =p_url where id_documento = p_id_documento;
	--actualizar el registro de la firma 
	update firma_participantes set firmado = true, fecha_firma = Now() where id_firma_participantes =p_id_firma;
	--obtener el nombre del usuario 
	select u.nombres into p_nombres_usuario from usuario u where cast(u.id_user as varchar(900))= p_id_user ;
	--aqui anadir al historial que se firmo el documento 
	insert into historial_proyecto (detalle,boton,tipo,id_proyecto,Descripcion, titulo)
	values (concat('Un usuario ha firmado el documento: ',p_nombres_usuario),
	false,13,cast(p_id_proyecto as int),'Se firma el documento','Firma documento');
	EXCEPTION
        -- Si ocurre un error en la transacción principal, revertir
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE EXCEPTION 'Ha ocurrido un error en la transacción principal: %', SQLERRM;
END;
$$;


	select distinct hp.tipo  from historial_proyecto hp order by hp.tipo asc;

	update firma_participantes set firmado = false, fecha_firma = Now() where id_firma_participantes =2;

























--Funcion de John arreglada para listar los proyectos por usuario y area 
-drop function if exists public.proyectos_areas(integer, boolean,character varying);

CREATE OR REPLACE FUNCTION public.proyectos_areas(p_id_area integer, p_is_admin boolean, p_id_user character varying)
 RETURNS TABLE(p_id_proyecto integer, p_titulo character varying, p_codigo character varying, 
 p_estado boolean, p_prefijo character varying, p_categoria character varying, p_subir boolean, 
 p_titulo_nivel character varying, p_tipo_nivel integer, p_reforma boolean)
 LANGUAGE plpgsql
AS $function$
begin
	--Muestra todos los proyectos si es admin
	if(p_is_admin)then 
		return query
		select DISTINCT  * from 
		(
		select p.id_proyecto,p.titulo, p.codigo, p.estado,p.prefijo_proyecto, cp.nombre_categoria ,p.subir_docs,cast('Elaboracion'as varchar(500)),cast(1 as int), p.reforma
		from proyectos p inner join categorias_proyecto cp on p.id_categoria=cp.id_categoria
		where p.id_area_responsable = p_id_area and  p.publicado = false
		union ALL
		select p.id_proyecto,p.titulo, p.codigo, p.estado,p.prefijo_proyecto, cp.nombre_categoria, p.subir_docs, n.titulo,n.tipo_nivel, p.reforma
		from niveles_proyecto np 
		inner join estado_nivel en on np.id_niveles_pro =en.id_nivel 
		inner join flujo_proyecto fp on np.id_flujo = fp.id_flujo 
		inner join proyectos p on fp.id_proyecto =p.id_proyecto 
		inner join niveles n on np.id_nivel =n.id_nivel 
		inner join categorias_proyecto cp on p.id_categoria =cp.id_categoria 
		where np.id_departamento = p_id_area and np.estado =true and en.estado =true and en.enviando = false and p.publicado = false and p.estado = true
		) as x order by x.titulo asc;	
	else 
		return query
		
		--- si no es admin entonces muestra los proyecto solo si el usario pertenece a estos
		select distinct * from 
		(
			select p.id_proyecto,p.titulo, p.codigo, p.estado,p.prefijo_proyecto, cp.nombre_categoria ,p.subir_docs,cast('Elaboracion'as varchar(500)),cast(1 as int), p.reforma
			from proyectos p inner join categorias_proyecto cp on p.id_categoria=cp.id_categoria
			inner join participantes p2 on p.id_proyecto = p2.id_proyecto
			inner join usuarios_areas ua on p2.id_relacion_usu_ar = ua.id_relacion 
			where p.id_area_responsable = p_id_area 
			and p.publicado = false 
			and p2.estado = true
			and p.estado = true 
			and ua.estado = true
			and ua.id_area = p_id_area
			and cast(ua.id_usuario as varchar(500)) = p_id_user
		union ALL
			select p.id_proyecto,p.titulo, p.codigo, p.estado,p.prefijo_proyecto, cp.nombre_categoria, p.subir_docs, n.titulo,n.tipo_nivel, p.reforma
			from niveles_proyecto np 
			inner join estado_nivel en on np.id_niveles_pro =en.id_nivel 
			inner join flujo_proyecto fp on np.id_flujo = fp.id_flujo 
			inner join proyectos p on fp.id_proyecto =p.id_proyecto 
			inner join niveles n on np.id_nivel =n.id_nivel 
			inner join categorias_proyecto cp on p.id_categoria =cp.id_categoria
			inner join participantes pa on p.id_proyecto = pa.id_proyecto
			inner join usuarios_areas ua on pa.id_relacion_usu_ar = ua.id_relacion
			where np.id_departamento = p_id_area
			and np.estado =true 
			and en.estado =true 
			and en.enviando = false 
			and p.publicado = false 
			and p.estado = true
			and pa.estado = true
			and ua.id_area = p_id_area
			and cast(ua.id_usuario as varchar(500)) = p_id_user
		)
		as x order by x.titulo asc;
		
	end if;
end;
$function$
;



--03/12/2023 --Retorna el proyecto xd


--Verificar que no se suba de nivel un proyecto sin tener un documento activo
select * from proyectos p where p.codigo ='S2345-FDCDE-NORMA-1.0';
--id => 44
select case when COUNT(*) > 0 then true else false end as Indicador from documentos_proyectos dp where dp.id_proyecto = 44;


select * from documentos_proyectos;

select * from flujo_proyecto fp where fp.id_proyecto = 44; --89
select * from niveles_proyecto np where id_flujo = 89;

update flujo_proyecto set estado =false where id_proyecto = 44;
delete from niveles_proyecto where id_flujo = 89;
delete from  estado_nivel en where en.id_nivel in (263,264,265) 

select * from estado_nivel en where en.id_nivel in (263,264,265) 


--Editar el procedimiento almacenado que sube de nivel para evitar que se suba de nivel un documento que no existe 
-- DROP PROCEDURE public.subir_primer_nivel(json);

--drop procedure subir_primer_nivel
update documentos_proyectos set estado = false where id_proyecto = 44 
	select case when COUNT(*) > 0 then true else false end as Indicador  
	from documentos_proyectos dp where dp.id_proyecto = 44 and dp.estado;


--modificar el procedimiento almacenado para que no se pueda subir de nivel si no existe el documento 
CREATE OR REPLACE PROCEDURE public.subir_primer_nivel(IN p_data json, id_pro int)
 LANGUAGE plpgsql
AS $procedure$
declare
	p_p_data JSON;
	p_id_nivel int;
	p_numero int;
	p_titulo varchar(100);
	p_nombre_area varchar(100);
	p_id_proyecto int;
	p_id_area int;
	p_id_relacion int;
	p_no_existe_doc bool;
begin
	--Crear una exepcion de que no se puede subir de nivel porque no hay un documento activo en el proyecto 
	--	select case when COUNT(*) > 0 then true else false end as Indicador from documentos_proyectos dp where dp.id_proyecto = 44 and dp.estado;
	select case when COUNT(*) > 0 then true else false end as Indicador into p_no_existe_doc from documentos_proyectos dp where dp.id_proyecto = id_pro and dp.estado;
	if p_no_existe_doc = false then
			raise exception 'No puede subir nivel si no existe un documento activo en el proyecto';
	end if;
	--raise exception 'El prefijo del proyecto tiene que tener 5 digitos';
	FOR p_p_data IN SELECT * FROM json_array_elements(p_data)
    loop
       p_id_nivel := (p_p_data ->> 'id_nivel')::integer;
	   p_numero := (p_p_data ->> 'numero')::integer;
		--preguntar si es nivel 0 es decir elaboracion, de ser asi, editar el nivel 
      	if(p_numero=0)then
      		--editar 
      		update estado_nivel set observacion='Enviado al siguiente nivel', estado_nivel='Enviado', enviando=true
      		where id_nivel = p_id_nivel;
      	else 
      		--sino ingresar un nuevo estado nivel 
      	insert into estado_nivel(id_nivel,estado_nivel) values (p_id_nivel,'En revision');
      	--aqui consultar a que tipo de nivel pertenece ese id_nivel, es decir Revision, Elboracion, ETC y al area que le pertenece para poder insertar en el historial del proyecto
      select n.titulo ,ad.nombre_area , ad.id_area 
      	into p_titulo,p_nombre_area, p_id_area
		from niveles_proyecto np 
		inner join niveles n on np.id_nivel =n.id_nivel 
		inner join area_departamental ad on np.id_departamento = ad.id_area 
		where np.id_niveles_pro = p_id_nivel;
		--aqui obteener el id del proyecto 
		select fp.id_proyecto into p_id_proyecto from
		niveles_proyecto np
		inner join flujo_proyecto fp on np.id_flujo =fp.id_flujo 
		where np.id_niveles_pro = p_id_nivel ;
		--aqui insertar la wea fobe 
		insert into historial_proyecto (detalle,boton,tipo,id_proyecto,Descripcion, titulo)
		values (concat('El proyecto subió al nivel: ',p_titulo, ' que pertenece al area: ',p_nombre_area),false,6,p_id_proyecto,'Subida de niveles','Subir nivel');
		--aqui insertar el usuario administrador de ese nivel xd skere sjjsjs skere 
		--obtener el id de la relacion usuario_area si es administrador del area del que se obtiene el id 
		select ua.id_relacion into p_id_relacion  from usuarios_areas ua where ua.rol_area and ua.estado and ua.id_area =p_id_area;
		--insertar 
		insert into participantes(id_rol,id_relacion_usu_ar,id_proyecto) values (1,p_id_relacion,p_id_proyecto);
      	end if;
    end loop;
	EXCEPTION
        -- Si ocurre un error en la transacción principal, revertir
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE EXCEPTION 'Ha ocurrido un error en la transacción principal: %', SQLERRM;	
END;
$procedure$
;


--
--modificar la vista de la lista de usuarios para que permita filtrar por cualquier campo segun el dato que se envie xd
 select * from users_paginacion_busqueda('172430566');
 select * from users_total_paginacion_busqueda('172430566');

CREATE OR REPLACE function users_paginacion_busqueda(palabra_clave character varying, numero_pagina integer DEFAULT 1)
 RETURNS TABLE(userid character varying, nombres_user character varying, tip_iden character varying, identi character varying, correo_personal_user character varying, correo_institucional_user character varying, numero_celular_user character varying, estado_user boolean, url_foto_user character varying, nombre_firma_user character varying, isadmin_user boolean, estadou character varying)
 LANGUAGE plpgsql
AS $function$

begin
	IF numero_pagina IS NULL OR numero_pagina <= 0 THEN
        numero_pagina := 1;
    END IF;
	
		return query
		SELECT
			cast(id_user as varchar(500)) as UsuarioID,nombres,tipo_identificacion,identificacion,correo_personal,correo_institucional,numero_celular,estado,url_foto,nombre_firma,isadmin,
			cast (case when estado then 'Habilitado' else 'Deshabilitado' end as varchar(50)) as estado_descripcion
		FROM usuario
		--filtro para filtrar por todos los campos mediante una palabra clave
		WHERE (nombres ILIKE '%' || palabra_clave || '%') or (correo_personal  ILIKE '%' || palabra_clave || '%') or (correo_institucional  ILIKE '%' || palabra_clave || '%') or (numero_celular  ILIKE '%' || palabra_clave || '%') or (nombre_firma  ILIKE '%' || palabra_clave || '%') or (cast(id_user as varchar(500)) ILIKE '%' || palabra_clave || '%') or (identificacion  ILIKE '%' || palabra_clave || '%')
		ORDER BY nombres -- Ordenar por nombres para obtener resultados en orden alfabético
		LIMIT 5 -- Número de filas por página
		OFFSET ((numero_pagina  - 1) * 5); -- Calcular el desplazamiento en función de la página seleccionada
end;
$function$
;

--modificar la otra consulta que da los numeros de paguinas para filtrar por nombres xd 
CREATE OR REPLACE FUNCTION users_total_paginacion_busqueda(palabra_clave character varying)
 RETURNS TABLE(r_total_paginas numeric)
 LANGUAGE plpgsql
AS $function$
DECLARE
    numero_pagina numeric default 5;
begin
	return query
	SELECT CEIL(COUNT(*)::numeric / numero_pagina) as total_paginas
	FROM usuario
	WHERE (nombres ILIKE '%' || palabra_clave || '%') or (correo_personal  ILIKE '%' || palabra_clave || '%') or (correo_institucional  ILIKE '%' || palabra_clave || '%') or (numero_celular  ILIKE '%' || palabra_clave || '%') or (nombre_firma  ILIKE '%' || palabra_clave || '%') or (cast(id_user as varchar(500)) ILIKE '%' || palabra_clave || '%') or (identificacion  ILIKE '%' || palabra_clave || '%')
	;
end;
$function$
;

delete from usuario us where us.identificacion = '1020304050'

--03/12/2023 
--crear una funcion para filtrar la busqueda de las areas en SuperUsuario
select * from area_allData();

-- DROP FUNCTION public.area_alldata();

CREATE OR REPLACE FUNCTION area_alldata_busqueda(palabra_clave character varying)
 RETURNS TABLE(area_id integer, nombrearea character varying, estadoarea boolean, logoarea character varying, prefijo character varying)
 LANGUAGE plpgsql
AS $function$
begin
	return query
	select ad.id_area, ad.nombre_area, ad.estado,ad.logo_url, ad.prefijo_departamento from area_departamental ad
	where (ad.nombre_area ILIKE '%' || palabra_clave || '%') or (ad.prefijo_departamento ILIKE '%' || palabra_clave || '%');
end;
$function$
;

select * from area_alldata_busqueda('FDC');
select * from area_departamental ad where ad.prefijo_departamento = 'AREAP'; --64
delete from area_departamental where prefijo_departamento = 'AREAP'

select * from niveles_areas where id_area_hijo = 64
delete from niveles_areas where id_area_hijo = 64 


select * from niveles_areas

select * from empresa_URl()

select * from jerarquias_niveles jn ;
select * from tipos_jerarquia tj ;
select * from niveles n ;

--Limpiar la base de datos 
--skere modo diablo
--xdxdxd se retoma este proyecto 


--LIMPIAR BD STEPS
DELETE FROM guias_proyectos;
DELETE FROM historial_flujo ;
DELETE FROM historial_proyecto ;
DELETE FROM  documentos_proyectos ;
DELETE FROM  reformas ;
DELETE FROM publicacion_proyecto ;
DELETE FROM  firma_participantes ;
DELETE FROM firma_proyecto ;
DELETE FROM estado_nivel ;
DELETE FROM documentos_extras ;
DELETE FROM niveles_proyecto ;
DELETE FROM flujo_proyecto ; 
DELETE FROM  participantes ;
DELETE FROM niveles_areas ;
DELETE FROM usuarios_areas ;
DELETE FROM proyectos ;
DELETE FROM area_departamental ;
DELETE from usuario where isadmin = false;
delete from categorias_proyecto;
--eliminar todos los usuarios menos el super usuario
select * from usuario u ;
--eliminar los flujos no se usan y que no tienen nada que ver xd 
select * from jerarquias_niveles jn  where id_tipo_jerarquia in (4,8,9);
select * from tipos_jerarquia tj ; (4,8,9)
select *from niveles n where id_nivel in (1,3,5);


select * from categorias_proyecto cp ;
update  categorias_proyecto set CategoriaPersonalizada= true 

--añadir un nuevo campo a categoria para saber si la categoria permite seleccionar los encargados del nivel superior 
alter table categorias_proyecto 
add column CategoriaPersonalizada BOOL not null default false;


ALTER TABLE categorias_proyecto  
DROP COLUMN Seleccionar_participantes_superiores;



select * from tipos_jerarquia tj ;


select * from tipos_jerarquia where estado=false 
delete from tipos_jerarquia where estado=false 

delete from jerarquias_niveles jn where id_tipo_jerarquia in (4,8,9);



select * from niveles n ;
select * from jerarquias_niveles jn inner join niveles n on jn.id_nivel_padre =n.id_nivel inner join niveles n2 on jn.id_nivel_hijo =n2.id_nivel 
inner join niveles n3 on jn.id_cabecera =n3.id_nivel ;


1
5
9
5


delete from  niveles n where id_nivel not in (1,5,9,3)




--crear tabla de subcategorias de proyectos 
create table sub_categoria(
	id_sub_categoria INT GENERATED ALWAYS AS IDENTITY,
	titulo_sub_categoria varchar(200) not null ,
	fecha_creacion TIMESTAMPTZ DEFAULT Now(),
	estado bool not null default true,
		Primary Key(id_sub_categoria)
);

alter table sub_categoria 
add column 	descripcion varchar(200) not null;

select * from sub_categoria

--añadir una nueva columna para juntar sub categoria con proyecto 
select * from proyectos p;

alter table proyectos 
add column id_sub_categoria int not null;

alter table proyectos add constraint FK_Id_Sub_Categoria foreign key (id_sub_categoria) references sub_categoria(id_sub_categoria);


--funcion que retorna la lista de subcategorias 
select * from lista_sub_categorias()

drop function lista_sub_categorias()
create or replace function lista_sub_categorias()
returns table
(
	t_id_categoria int,t_nombre_categoria varchar(800), t_estado BOOL ,t_descripcion varchar(800)
)
language 'plpgsql'
as
$BODY$
begin
	return query
	 select sc.id_sub_categoria, sc.titulo_sub_categoria, sc.estado, sc.descripcion from sub_categoria sc ;
end;
$BODY$

--------------------------------------------------
alter table sub_categoria
  add constraint UQ_Titulo_sub_categoria
  unique (titulo_sub_categoria);
--procedimiento para crear subcategoria 
 
 select * from sub_categoria sc ;
call crear_sub_categoria('Proyecto Integrador','Proyectos Integradores');
Create or Replace Procedure crear_sub_categoria(p_titulo_sub_categoria varchar(200),
										   p_descripcion varchar(200))
Language 'plpgsql'
AS $$
begin
	insert into sub_categoria(
								titulo_sub_categoria,
								descripcion
								)values(
								p_titulo_sub_categoria,
								p_descripcion
								);
	
	 EXCEPTION
        WHEN OTHERS THEN
            -- Realiza un rollback explícito para deshacer los cambios
            -- hechos en esta función del trigger
            RAISE EXCEPTION 'Error en el trigger: %', SQLERRM;
            ROLLBACK;
END;
$$;

--procedimiento para cambiar el estado de la subcategoria 
Create or Replace Procedure Estado_Sub_Categoria(
										   p_id_cate varchar(100)
										 )
Language 'plpgsql'
AS $$
declare 
	Estado_old bool;
Begin
--update area_departamental  set cabezera = false where id_area = 11;
	select into Estado_old not estado from sub_categoria where  id_sub_categoria=cast(p_id_cate as int) ;
		update sub_categoria set estado  = Estado_old
		where  id_sub_categoria = cast(p_id_cate as int);
COMMIT;
END;
$$;

select * from sub_categoria;


--en proyectos 
--agregar el campo sub-categoria Listo 
--agregar si aplica firmar en el proyecto --> tambien aplica contraportada
--agregar si aplica encabezado
--agregar si aplica portada --> la portada se debe seleccionar dependiendo de la categoria principal del proyecto
select * from lista_sub_categorias();
select * from proyectos p ;

alter table proyectos 
add column requiere_firmas bool default true not null;
alter table proyectos 
add column requiere_encabezado bool default true not null;
alter table proyectos 
add column requiere_portada bool default true not null;



-- DROP PROCEDURE public.crear_proyecto(varchar, int4, int4, varchar);

CREATE OR REPLACE PROCEDURE public.crear_proyecto_new_procedure
(IN p_titulo character varying, IN p_id_area integer, IN p_id_categoria integer, IN p_prefijo_proyecto character varying, 
	in p_id_sub_categoria int, in p_Portada bool, in p_encabezado bool, in p_requiere_firmas bool )
 LANGUAGE plpgsql
AS $procedure$
declare 
	p_id_proyecto  int;
	p_nombre_area varchar(500);
begin
	if trim(p_titulo)='' then
			raise exception 'Titulo no puede ser vacio';	
	end if;
	if trim(p_prefijo_proyecto)='' then
			raise exception 'Prefijo no puede ser vacio';
	end if;
	
	insert into proyectos(titulo,id_area_responsable,id_categoria,prefijo_proyecto,versionp, id_sub_categoria, requiere_firmas , requiere_encabezado, requiere_portada )values
	(p_titulo,p_id_area,p_id_categoria,p_prefijo_proyecto,1.0, p_id_sub_categoria, p_requiere_firmas,p_encabezado, p_Portada);
	--Aqui anadir agregar a historial proyecto
	--primero obtener el id del ultimo proyecto creado 
	select id_proyecto into p_id_proyecto from proyectos p order by p.id_proyecto desc limit 1;
	--obtener el nombre del area 
	select ad.nombre_area into p_nombre_area from area_departamental ad where ad.id_area = p_id_area;
	--ahora insertar el historial del proyecto con tipo=1 que seria creacion 
	insert into historial_proyecto (detalle,boton,tipo,id_proyecto,Descripcion, titulo)
	values (concat('El area: ',p_nombre_area, ' creó el proyecto : ',p_titulo),false,1,p_id_proyecto,'Se crea un proyecto','Creación del proyecto');

	 EXCEPTION
        WHEN OTHERS THEN
            -- Realiza un rollback explícito para deshacer los cambios
            -- hechos en esta función del trigger
            RAISE EXCEPTION 'Error en el trigger: %', SQLERRM;
            ROLLBACK;
END;
$procedure$
;

delete from proyectos;
delete from participantes;


select * from proyectos p ;


--crear un flujo desde la categoria para que cada proyecto que se cree tome el flujo definido desde la categoria
--como es de categoria Titulacion entonces hay que definir la parte 1 xd

--Primero se escoje entre la lista de flujos definidos 
--este id lo tiene que tener la categoria como Foreing key 
select * from tipos_jerarquia tj;
--un ejemplo del flujo que genera el proyecto;
select * from flujo_proyecto fp ;
--92
select * from niveles_proyecto np where np.id_flujo =92;

select * from  jerarquias_niveles jn 
inner join niveles n on jn.id_nivel_padre = n.id_nivel 
inner join niveles n2 on jn.id_nivel_hijo = n2.id_nivel 
inner join niveles n3 ON jn.id_cabecera = n3.id_nivel 

--CREAR UNA TABLA LLAMADA FLUJO-CATEGORIA 
select * from flujo_proyecto fp ;
-----------------------------
create table flujo_categoria(
	Id_flujo int generated always as identity,
	fecha_creacion  TIMESTAMPTZ DEFAULT Now(),
	id_categoria int not null,
	Estado bool not null default true,
	id_tipo_jerarquia int not null,
	--Estado_Nivel bool not null default false,
	primary Key(Id_flujo)
);
alter table flujo_categoria add constraint FK_id_tipo_jerarquia_categoria
FOREIGN KEY (id_tipo_jerarquia) references tipos_jerarquia(id_tipo);

alter table flujo_categoria add constraint FK_id_tipo_categoria
FOREIGN KEY (id_tipo_jerarquia) references categorias_proyecto(id_categoria);

select * from tipos_jerarquia tj ;
select * from categorias_proyecto cp ;
-----------------------------

---Realizar una funcion para crear un flujo de proyecto mediante categoria 
-- DROP PROCEDURE public.crear_flujo_proyecto(int4, int4, json);
select * from niveles_proyecto np ;
--crear la tabla para crear los flujos segun la categoria 
create table niveles_proyecto_categoria(
	Id_Niveles_pro int generated always as identity,
	Id_Departamento int not null,
	Id_Flujo int not null,
	fecha_creacion  TIMESTAMPTZ DEFAULT Now(),
	Nivel int not null,
	--Tipo_Nivel int not null,
	Estado bool not null default true,
	Id_nivel int not null,
	Enviado bool not null default true,
	primary Key(Id_Niveles_pro)
);
select * from niveles_proyecto_categoria;

select * from flujo_categoria fc 
--conectar la tabla niveles_proyecto_categoria con flujo categoria
alter table niveles_proyecto_categoria add constraint FK_ID_Flujo_Categoria_niveles_proyecto
FOREIGN KEY (Id_Flujo) references flujo_categoria(Id_Flujo);
--conectar la tabla niveles_proyecto_categoria con departemntos
alter table niveles_proyecto_categoria add constraint FK_ID_Flujo_Categoria_area_departamental
FOREIGN KEY (Id_Departamento) references area_departamental(id_area);
--conectat la tabla niveles_proyecto_categoria con niveles 
alter table niveles_proyecto_categoria add constraint FK_ID_Flujo_Categoria_Id_nivel
FOREIGN KEY (Id_nivel) references niveles(id_nivel);

select * from  niveles n ;
select * from categorias_proyecto cp 

--modificar esta funcion pero para categoria-flujo
--drop PROCEDURE public.crear_flujo_categoria( IN p_id_categoria integer, IN p_id_tipo integer, IN p_data json)
--14
--6
 INSERT INTO flujo_categoria (id_categoria, id_tipo_jerarquia)
    VALUES (14, 6);

ALTER TABLE public.flujo_categoria 
 ADD CONSTRAINT fk_id_tipo_categoria_id 
FOREIGN KEY (id_categoria) REFERENCES categorias_proyecto(id_categoria)

select * from categorias_proyecto cp where cp.id_categoria =14;
select * from tipos_jerarquia tj where tj.id_tipo =6

CREATE OR REPLACE PROCEDURE public.crear_flujo_categoria(
    IN p_id_categoria integer, IN p_id_tipo integer, IN p_data json)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    p_p_data JSON;
    ID_F int = 0;
    p_id_departamtento int;
    p_id_nivel int;
    p_nivel int;
    p_id_nivel_flujo int;
    p_primer_nivel int;
    p_ultimo_historial int;
    es_reforma bool;
    peso DECIMAL(5, 1);
    Prefijo_proyect varchar(50);
    Prefijo_area varchar(50);
    Prefijo_categoria varchar(50);
BEGIN
    --select * from flujo_categoria;
    --primero se crea el flujo del proyecto
    INSERT INTO flujo_categoria (id_categoria, id_tipo_jerarquia)
    VALUES (p_id_categoria, p_id_tipo);
    
    select into ID_F id_flujo  from flujo_categoria fp order by id_flujo desc limit 1 ;
    --y se procede a recorrer el json para guardar los niveles según el ID
    FOR p_p_data IN SELECT * FROM json_array_elements(p_data)
    LOOP
        --solo insertar si id_area_f es diferente de 0 
        p_id_departamtento := (p_p_data ->> 'id_area_f')::integer;
        IF p_id_departamtento <> 0 THEN
            p_id_nivel  := (p_p_data ->> 'id_nivel_f')::integer;
            p_nivel  := (p_p_data ->> 'nivel')::integer;
            --se insertan los valores en la tabla según el json
            INSERT INTO niveles_proyecto_categoria(id_departamento, id_flujo, id_nivel, nivel)
            VALUES (p_id_departamtento, ID_F, p_id_nivel, p_nivel);
            --select * from niveles_proyecto_categoria;
        END IF;
    END LOOP;

    EXCEPTION
        -- Si ocurre un error en la transacción principal, revertir
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE EXCEPTION 'Ha ocurrido un error en la transacción principal: %', SQLERRM;
END;
$procedure$;

select * from flujo_categoria fc ;

select cp.nombre_categoria, (select case when COUNT(*)>=1 then true else false end as Tiene_Flujo from flujo_categoria fc where fc.id_categoria=cp.id_categoria  limit 1)
from categorias_proyecto cp;

--agregar una nueva columna xd 
-- DROP FUNCTION public.lis_categorias();

select * from lis_categorias();

CREATE OR REPLACE FUNCTION public.lis_categorias()
 RETURNS TABLE(t_id_categoria integer, t_nombre_categoria character varying, t_prefijo_categoria character varying, 
 t_descripcion character varying, t_estado boolean, t_est character varying, Tiene_Flujo bool)
 LANGUAGE plpgsql
AS $function$
begin
	return query
	select cp.id_categoria ,cp.nombre_categoria ,cp.prefijo_categoria ,cp.descripcion ,cp.estado,
	cast(case when estado then 'Habilitado' else 'Deshabilitado' end  as varchar(50)),
	(select case when COUNT(*)>=1 then true else false end as Tiene_Flujo from flujo_categoria fc where fc.id_categoria=cp.id_categoria  limit 1)
	from categorias_proyecto cp;
end;
$function$
;





---Devolver esto pero con categorias xd skere modo diablo
select ad.id_area ,ad.nombre_area ,n.titulo ,np.nivel 
	from niveles_proyecto np
	inner join area_departamental ad on np.id_departamento =ad.id_area 
	inner join niveles n ON np.id_nivel =n.id_nivel 
	where np.id_flujo =36
	order by np.nivel asc;


--13
select 0,'Elaboracion', 'Elaboracion', 0
union all 
select ad.id_area ,ad.nombre_area ,n.titulo ,np.nivel 
	from niveles_proyecto_categoria np
	inner join area_departamental ad on np.id_departamento =ad.id_area 
	inner join niveles n ON np.id_nivel =n.id_nivel 
	where np.id_flujo =13
	order by np.nivel asc
	
	
select * from categorias_proyecto cp ;

select * from niveles_categoria_flujo(14);


drop FUNCTION public.niveles_categoria_flujo( p_id_categoria int)


CREATE OR REPLACE FUNCTION public.niveles_categoria_flujo( p_id_categoria int)
 RETURNS TABLE(
 	area_id integer, nombrearea character varying, nivel character varying, numero integer
 )
 LANGUAGE plpgsql
AS $function$
declare 
	p_id_flujo int;
begin
	--OBTENER EL ID DEL FLUJO DEPENDIENDO DEL ID DE LA CATEGORIA 
	select fc.id_flujo  into  p_id_flujo from flujo_categoria fc where fc.id_categoria=p_id_categoria;
	--RETORNAR MAPEO 
	return query
	select * from 
	((SELECT 0, 'Elaboracion', 'Elaboracion', 0)
	UNION ALL 
	(SELECT ad.id_area, ad.nombre_area, n.titulo, np.nivel 
	FROM niveles_proyecto_categoria np
	INNER JOIN area_departamental ad ON np.id_departamento = ad.id_area 
	INNER JOIN niveles n ON np.id_nivel = n.id_nivel 
	WHERE np.id_flujo = p_id_flujo
	ORDER BY np.nivel asc))as x;
end;
$function$
;

	select fc.id_flujo  into  p_id_flujo from flujo_categoria fc where fc.id_categoria=p_id_categoria;


select * from categorias_proyecto cp ;
--crear el trigger despues de crear el proyecto para saber si la categoria de dicho proyecto tiene un flujo determinado
--si lo tiene entonces copiar el flujo para el nuevo proyecto 
--primero obtener el id de la categoria

select p.id_categoria  from proyectos p where p.id_proyecto = 46;
--obtener si el proyecto es reforma
select p.reforma  from proyectos p where p.id_proyecto = 46;

--id = 14
--en el trigger omitir ese paso porque el id = new.id_categoria
--obtener si la categoria tiene por lo menos tiene un flujo
select case when COUNT(*)>=1 then true else false end from flujo_categoria fc where fc.id_categoria =14;
--si es true entonces copiar el flujo de la categoria
--con la misma logica que el de rechazar documento en un nivel hacer esto 
-- DROP PROCEDURE public.rechazar_proyecto(int4, varchar);

select * from categorias_proyecto cp 
	--------------------ESTE MODIFICAR PARA COPIAR DESDE LOS NIVELES DE LA CATEGORIA AL PROYECTO
	
--crear el trigger after insert 
create or replace function categoria_proyecto_flujo() returns trigger 
as 
$$
---Declarar variables
declare
	Padre_Arbol int;
	is_reforma bool;
	Tiene_flujo bool;
	p_id_flujo int;
begin 
	
	--obtener si el proyecto es reforma
	select p.reforma into is_reforma from proyectos p where p.id_proyecto = new.id_proyecto;
	--id = 14
	--en el trigger omitir ese paso porque el id = new.id_categoria
	--obtener si la categoria tiene por lo menos tiene un flujo
	select case when COUNT(*)>=1 then true else false end into Tiene_flujo from flujo_categoria fc where fc.id_categoria =new.id_categoria;
	--si es true entonces copiar el flujo de la categoria
	--con la misma logica que el de rechazar documento en un nivel hacer esto 
	if Tiene_flujo and not is_reforma then
		--p_id_flujo --> primer flujo de la categoria 
		select fc.id_flujo into p_id_flujo from flujo_categoria fc where fc.id_categoria = new.id_categoria and estado order by fc.fecha_creacion asc limit 1;
	
		--select np.id_niveles_pro  from niveles_proyecto_categoria np  where np.id_flujo =13 and np.estado;
		--13
		--select np.id_niveles_pro  from niveles_proyecto_categoria np  where np.id_flujo =13 and np.estado;
		--Llamar al cursor 
 			PERFORM copiar_niveles_categoria_proyecto(new.id_area_responsable, new.id_proyecto , new.id_categoria ,p_id_flujo);
	end if;
		
return new;
end
$$
language 'plpgsql';




create trigger insproyecto_flujo_categoria after
insert
    on
    public.proyectos for each row execute function categoria_proyecto_flujo()

select * from proyectos p 

CREATE OR REPLACE FUNCTION public.copiar_niveles_categoria_proyecto( p_ID_Departamente int ,p_id_proyecto int ,p_id_categoria int , p_id_flujo int)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
 	ID_nivel_c int;
 	ID_Departamente int;
 	ID_nivel int;
 	Nivel int;
 	P_id_flujo_new int;
 	--/NUEVO
 	p_id_tipo_jerarquia int;
 	p_id_cabecera int;
    curCopiar cursor for select id_niveles_pro  from niveles_proyecto_categoria np where np.id_flujo =p_id_flujo and np.estado;
begin
	--PRIMERO CREAR EL FLUJO PROYECTO
	--Obtener el tipo jerarquia que tiene el flujo categoria 
	--IMPORTANTE ESCOJER EL PRIMERO XQ EL PRIMER FLUJO ENCONTRADO VA A SER PARA LOS PROYECTOS RECIEN ELABORADOS SIN NINGUNA REFORMA
	select  fc.id_tipo_jerarquia into p_id_tipo_jerarquia  from flujo_categoria fc where fc.id_categoria =p_id_categoria and estado order by fc.fecha_creacion asc limit 1;  --new.id_categoria;
	--crear un nuevo flujo segun el id del proyecto 
	insert into flujo_proyecto (id_proyecto ,id_tipo_jerarquia)values
	(p_id_proyecto,p_id_tipo_jerarquia);
	--obtener el id flujo ultimo creado 
 	select fp2.id_flujo  INTO P_id_flujo_new  from flujo_proyecto fp2 where fp2.id_proyecto  =p_id_proyecto and estado = true ;
	--COMO LA CATEGORIA NO TIENE EL PRIMER NIVEL = ELABORACION ENTONCES ESE INSERTARLO MANUALMENTE
	select jn.id_cabecera  into p_id_cabecera from jerarquias_niveles jn where jn.id_tipo_jerarquia =p_id_tipo_jerarquia limit 1;
	--Insertar el primer nivel Elaboracion
	insert into niveles_proyecto(id_departamento,id_flujo,id_nivel,nivel)
	values(p_ID_Departamente,P_id_flujo_new,p_id_cabecera,0);
   open curCopiar;
	fetch next from curCopiar into ID_nivel_c;
	while (Found) loop	
	 select np.id_departamento, np.id_nivel ,np.nivel into ID_Departamente,ID_nivel,Nivel from niveles_proyecto_categoria np where np.id_niveles_pro=ID_nivel_c;
		--esto tiene que insertar el cursor en la tabla
		insert into niveles_proyecto(id_departamento,id_flujo,id_nivel,nivel)
		values(ID_Departamente,P_id_flujo_new,ID_nivel,Nivel);
		--cerrar el cursor 
	fetch curCopiar into ID_nivel_c;
	end loop;
	close curCopiar;
	EXCEPTION
        -- Si ocurre un error en la transacción principal, revertir
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE EXCEPTION 'Ha ocurrido un error en el trigger: %', SQLERRM;
END;
$function$
;

	
--analizar lo que esta sucediendo aqui 
  
call crear_proyecto_new_procedure(
'Tecnologico 2',
 68,
 14,
 'TECN2',
 3,
 true,
 false,
 false
);
	
	
	
	
	
	
	
	
	
--------------------ESTE MODIFICAR PARA COPIAR DESDE LOS NIVELES DE LA CATEGORIA AL PROYECTO ORIGINAL
CREATE OR REPLACE FUNCTION public.copiar_niveles_categoria_proyecto(p_id_flujo integer, p_id_proyecto integer, p_id_tipo integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
 	ID_nivel_c int;
 	ID_Departamente int;
 	ID_nivel int;
 	Nivel int;
 	P_id_flujo_new int;
    curCopiar cursor for select id_niveles_pro  from niveles_proyecto np where np.id_flujo =p_id_flujo and np.estado;
begin
	--crear un nuevo flujo segun el id del proyecto 
	insert into flujo_proyecto (id_proyecto ,id_tipo_jerarquia)values
	(p_id_proyecto,p_id_tipo);
	--obtener el id flujo ultimo creado 
 	select fp2.id_flujo  INTO P_id_flujo_new  from flujo_proyecto fp2 where fp2.id_proyecto  =p_id_proyecto and estado = true ;
	
   open curCopiar;
	fetch next from curCopiar into ID_nivel_c;
	while (Found) loop	
	 select np.id_departamento, np.id_nivel ,np.nivel into ID_Departamente,ID_nivel,Nivel from niveles_proyecto np where np.id_niveles_pro=ID_nivel_c;
		--esto tiene que insertar el cursor en la tabla
		insert into niveles_proyecto(id_departamento,id_flujo,id_nivel,nivel)
		values(ID_Departamente,P_id_flujo_new,ID_nivel,Nivel);
		--cerrar el cursor 
	fetch curCopiar into ID_nivel_c;
	end loop;
	close curCopiar;
	EXCEPTION
        -- Si ocurre un error en la transacción principal, revertir
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE EXCEPTION 'Ha ocurrido un error: %', SQLERRM;
END;
$function$
;

select * from rol_proyecto('00f1e857-f858-441e-8689-80d85b019cb1',57);
-- DROP FUNCTION public.rol_proyecto(varchar, int4);

CREATE OR REPLACE FUNCTION public.rol_proyecto(p_idu character varying, p_id_proyecto integer)
 RETURNS TABLE(	
 			p_titulo character varying, 
 			p_rol character varying, 
 			p_subir boolean, 
 			p_reforma boolean, 
 			p_codigo character varying, 
 			p_flujo boolean)
 LANGUAGE plpgsql
AS $function$
declare 
	p_id_area int;
begin
	select np.id_departamento into p_id_area  from proyectos p 
inner join flujo_proyecto fp on p.id_proyecto =fp.id_proyecto 
inner join niveles_proyecto np on np.id_flujo = fp.id_flujo 
inner join estado_nivel en on np.id_niveles_pro = en.id_nivel 
where p.id_proyecto =p_id_proyecto
order by np.nivel desc limit 1;

	return query
	select * from 
	(select 
	--ua.id_usuario ,
	--p.id_area_responsable,
	/*
	(select ua.id_usuario from usuarios_areas  ua where ua.id_area = 68 and ua.estado and 
		cast(ua.id_usuario as varchar(500))='00f1e857-f858-441e-8689-80d85b019cb1'),
	*/
	p.titulo,
	(select 
	case when ua.rol_area then cast('Admin' as varchar(100)) else cast('Not admin' as varchar(100)) end
	from usuarios_areas  ua where ua.id_area = p_id_area and ua.estado and 
		cast(ua.id_usuario as varchar(500))=p_idu),	--case when ua.rol_area then cast('Admin' as varchar(100)) else cast('Not admin' as varchar(100)) end ,
	p.subir_docs,p.reforma ,p.codigo 
	from proyectos p 
	inner join area_departamental ad on p.id_area_responsable =ad.id_area 
	--inner join usuarios_areas ua on ad.id_area =ua.id_area 
		where 
		--cast(ua.id_usuario as varchar(500))='c09cda3f-0346-4243-8e59-82d8741e32b1' and 
		--cast(ua.id_usuario as varchar(500))='00f1e857-f858-441e-8689-80d85b019cb1' and 
		p.id_proyecto=p_id_proyecto
		) as x inner join
	(select case when COUNT(*)>0 then true else false end as TieneFLujo from flujo_proyecto fp 
	where id_proyecto = p_id_proyecto and estado =true 
	) as y on 1=1;
end;
$function$
;
--57
select case when COUNT(*)>0 then true else false end as TieneFLujo from flujo_proyecto fp 
	where id_proyecto = p_id_area and estado =true 


CREATE OR REPLACE FUNCTION public.rol_proyecto_original(p_idu character varying, p_id_proyecto integer)
 RETURNS TABLE(p_titulo character varying, p_rol character varying, p_subir boolean, p_reforma boolean, p_codigo character varying, p_flujo boolean)
 LANGUAGE plpgsql
AS $function$
begin
	return query
	select * from
	(select p.titulo,case when ua.rol_area then cast('Admin' as varchar(100)) else cast('Not admin' as varchar(100)) end ,
	p.subir_docs,
	p.reforma ,
	p.codigo 
	from proyectos p 
	inner join area_departamental ad on p.id_area_responsable =ad.id_area 
	inner join usuarios_areas ua on ad.id_area =ua.id_area 
		where cast(ua.id_usuario as varchar(500))=p_idu and p.id_proyecto=p_id_proyecto) as x inner join
	(select case when COUNT(*)>0 then true else false end as TieneFLujo from flujo_proyecto fp 
	where id_proyecto = p_id_proyecto and estado =true ) as y on 1=1;
end;
$function$
;
--57


select * from usuarios_areas where id_area =68;



--consulta arreglad xd 

	

---
--obtener el nivel actual del proyecto



select * from usuarios_areas ua where ua.id_area =73;
select * from area_departamental ad where ad.id_area =73;
select * from proyectos p where p.id_area_responsable =73;
--id proyecto 57


select * from area_departamental ad ;
----
select *
	from proyectos p 
	inner join usuarios_areas ua on p.id_area_responsable =ua.id_area 
		where 
		cast(ua.id_usuario as varchar(500))='00f1e857-f858-441e-8689-80d85b019cb1' and 
		p.id_proyecto=57
--68
select * from proyectos p 
inner join participantes p2 on p.id_proyecto =p2.id_proyecto 
inner join usuarios_areas ua on p2.id_relacion_usu_ar = ua.id_relacion 
where p.id_proyecto=57 and p2.estado and ua.estado ;




select * from proyectos p where p.id_proyecto =57;
select * from guias_proyectos gp ;

--Cambiar la funcion de ver flujo para que alli mismo se puedan ver las revisiones 
select * from niveles_estado_proyecto(57);
-- DROP FUNCTION public.niveles_estado_proyecto(int4);
CREATE OR REPLACE FUNCTION public.niveles_estado_proyecto(p_id_proyecto integer)
 RETURNS TABLE(r_id_estado integer, r_estado boolean, r_fecha_estado character varying, r_observacion character varying, r_id_nivel integer, r_estado_nivel character varying, r_id_area integer, r_nombre_area character varying, r_nivel integer, click boolean, r_tipo_nivel character varying)
 LANGUAGE plpgsql
AS $function$
declare
	T_niveles bool;
begin
	select  into T_niveles
	case when count(*)>=1 then true else false end 
	from proyectos p 
	inner join flujo_proyecto fp on p.id_proyecto =fp.id_proyecto 
	inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
	inner join estado_nivel en on np.id_niveles_pro =en.id_nivel 
	where p.id_proyecto =p_id_proyecto and fp.estado = true;	

	--Si es true es porque tiene niveles entonces hay que retornar la data con todo en true 
	if(T_niveles) then
	return query
	select * from
			((	select 
	en.id_estado ,en.estado ,cast(TO_CHAR(en.fecha, 'DD-MON-YYYY') as varchar(500)),en.observacion ,en.id_nivel ,en.estado_nivel,ad.id_area ,ad.nombre_area ,np.nivel, cast(true as bool) ,  n.titulo 
	from proyectos p 
	inner join flujo_proyecto fp on p.id_proyecto =fp.id_proyecto 
	inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
	inner join estado_nivel en on np.id_niveles_pro =en.id_nivel 
	inner join area_departamental ad on np.id_departamento =ad.id_area 
	inner join niveles n on np.id_nivel =n.id_nivel 
	where p.id_proyecto =p_id_proyecto and fp.estado = true order by np.nivel asc )
			union all
			(select 
	0, false, 'Sin fecha', 'Sin enviar',0, 'Sin enviar', ad.id_area ,ad.nombre_area ,np.nivel, cast(true as bool) ,  n.titulo 
	--en.id_estado ,en.estado ,cast(TO_CHAR(en.fecha, 'DD-MON-YYYY') as varchar(500)),en.observacion ,
	--en.id_nivel ,en.estado_nivel,ad.id_area ,ad.nombre_area ,np.nivel, cast(true as bool) ,  n.titulo 
	from proyectos p 
	inner join flujo_proyecto fp on p.id_proyecto =fp.id_proyecto 
	inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
LEFT JOIN estado_nivel en ON np.id_niveles_pro = en.id_nivel -- Cambiado a LEFT JOIN
	inner join area_departamental ad on np.id_departamento =ad.id_area 
	inner join niveles n on np.id_nivel =n.id_nivel 
	where p.id_proyecto =p_id_proyecto  and en.id_nivel IS NULL and fp.estado  order by np.nivel asc ))as x;

	--sino es xq aun esta en elaboracion, entonces retornar data solo con dicho estado
	else 
	return query
			select 
	 cast(0 as int),cast(false as bool),cast(TO_CHAR(p.fecha_creacion, 'DD-MON-YYYY') as varchar(500)),cast('En elaboracion' as varchar(100)),
	 cast(0 as int),cast('No enviado' as varchar(100)),ad.id_area ,ad.nombre_area ,np.nivel , cast(false as bool), n.titulo 
		from proyectos p 
		inner join flujo_proyecto fp ON p.id_proyecto =fp.id_proyecto 
		inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
		inner join area_departamental ad ON np.id_departamento =ad.id_area 
		inner join niveles n on np.id_nivel =n.id_nivel 
		where p.id_proyecto =p_id_proyecto and fp.estado = true and np.nivel =0 order by np.nivel asc ;	
	end if;
end;
$function$
;

select * from proyectos p ;

--funcion para listar los flujos diponibles de una categoria 
select * from categorias_proyecto cp ;

create or replace function fu_lista_flujos_categoria(idu int)
returns table
(
	r_id_flujo int, r_estado bool, r_id_tipo_jerarquia int, r_fecha character varying
)
language 'plpgsql'
as
$BODY$
begin
	return query
	select fc.id_flujo,estado,id_tipo_jerarquia,cast(TO_CHAR(fc.fecha_creacion, 'DD-MON-YYYY') as varchar(500))
	from flujo_categoria fc where fc.id_categoria =idu order by fc.id_flujo asc;
end;
$BODY$




select * from fu_lista_flujos_categoria(14);
select * from niveles_categoria_flujo(13);
--13
-- DROP FUNCTION public.niveles_categoria_flujo(int4);

CREATE OR REPLACE FUNCTION public.niveles_categoria_flujo(p_id_categoria integer)
 RETURNS TABLE(area_id integer, nombrearea character varying, nivel character varying, numero integer)
 LANGUAGE plpgsql
AS $function$
declare 
	p_id_flujo int;
begin
	/*
	--OBTENER EL ID DEL FLUJO DEPENDIENDO DEL ID DE LA CATEGORIA 
	select fc.id_flujo  into  p_id_flujo from flujo_categoria fc where fc.id_categoria=p_id_categoria;
	*/
	--RETORNAR MAPEO 
	return query
	select * from 
	((SELECT 0, 'Elaboracion', 'Elaboracion', 0)
	UNION ALL 
	(SELECT ad.id_area, ad.nombre_area, n.titulo, np.nivel 
	FROM niveles_proyecto_categoria np
	INNER JOIN area_departamental ad ON np.id_departamento = ad.id_area 
	INNER JOIN niveles n ON np.id_nivel = n.id_nivel 
	WHERE np.id_flujo = p_id_categoria
	ORDER BY np.nivel asc))as x;
end;
$function$
;



--SEGUNDO FLUJO DE UNA CATEGORIA
--ANTES:
	--Anadir un campo NumReforma en proyecto que sea secuencial int 
	--Inicia en 1 default y si es uno entonces buscara si la categoria tiene flujo y si tiene flujo escojera el primero
	--Hacer un row number de los flujos categorias para escojer el adecuado
	--Cuando sea mayor a 1 es decir primeras reformas hasta n reformars:
		--Cuando se publique debe preguntar si la categoria tiene otro flujo mas entonces copiar el nuevo flujo y llevarse a todos los usuarios del nivel de elaboracion al nuevo nivel
		--Con sus revisores
--Ver los niveles de un flujo categoria con sus areas
select * from categorias_proyecto cp ;
select * from flujo_categoria fc where fc.id_categoria =14 order by fc.id_flujo desc;


---Verificar si se puede usar esta consulta para recorrer el cursor de copiar el siguiente flujo
--En esta consultada buscar el numero de flujo categoria segun el numero de reforma del proyecto por ejemplo si es 1 entonces escojer el rownumber 1 
select fc.id_flujo  from flujo_categoria fc 
where fc.id_categoria = 14 and estado 
order by fc.fecha_creacion asc limit 1;

select *  from niveles_proyecto_categoria np where np.id_flujo =13 and np.estado;
select *  from niveles_proyecto_categoria np where np.id_flujo =14 and np.estado;

--ordernado para sacar el numero que responde a la reforma 
--aqui hay que enviar el numero de reforma por ejemplo si es 2 entonces where row_num = 2 para obtener el id del flujo




---FUncion obtiene el p_id_flujo
select X.id_flujo from 
(SELECT
    fc.id_flujo,
    fc.id_categoria,
    ROW_NUMBER() OVER (PARTITION BY fc.id_categoria ORDER BY fc.fecha_creacion ASC) AS row_num
FROM
    flujo_categoria fc
WHERE
    fc.id_categoria = 14 AND estado
ORDER BY
    fc.fecha_creacion asc) as X
where X.row_num = (select numreforma from proyectos p where p.id_proyecto = 57)

-- DROP FUNCTION public.copiar_niveles_categoria_proyecto(int4, int4, int4, int4);

CREATE OR REPLACE FUNCTION public.copiar_niveles_categoria_proyecto_reformas( p_id_proyecto integer, p_id_categoria integer, p_id_flujo integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
 	ID_nivel_c int;
 	ID_Departamente int;
 	ID_nivel int;
 	Nivel int;
 	P_id_flujo_new int;
 	--/NUEVO
 	p_id_tipo_jerarquia int;
 	p_id_cabecera int;
    curCopiar cursor for select id_niveles_pro  from niveles_proyecto_categoria np where np.id_flujo =p_id_flujo and np.estado;
begin
	--PRIMERO CREAR EL FLUJO PROYECTO
	--Obtener el tipo jerarquia que tiene el flujo categoria 
	--IMPORTANTE ESCOJER EL FLUJO CATEGORIA QUE CORRESPONDE AL NUMERO DEL PROYECTO
	select X.tipJerarqui into p_id_tipo_jerarquia  from 
	(select  fc.id_tipo_jerarquia as tipJerarqui,
		    ROW_NUMBER() OVER (PARTITION BY fc.id_categoria ORDER BY fc.fecha_creacion ASC) AS row_num
	from flujo_categoria fc 
	where fc.id_categoria =p_id_categoria and estado 
	order by fc.fecha_creacion asc) as X 
	where X.row_num=(select p.numreforma from proyectos p where p.id_proyecto=p_id_proyecto); 
	--crear un nuevo flujo segun el id del proyecto 
	insert into flujo_proyecto (id_proyecto ,id_tipo_jerarquia)values
	(p_id_proyecto,p_id_tipo_jerarquia);
	--obtener el id flujo ultimo creado 

	select fp2.id_flujo into P_id_flujo_new from flujo_proyecto fp2 where fp2.id_proyecto = p_id_proyecto and estado = true order by fp2.fecha_creacion desc limit 1;
	
 	
 	--COMO LA CATEGORIA NO TIENE EL PRIMER NIVEL = ELABORACION ENTONCES ESE INSERTARLO MANUALMENTE QUE ES EL EQUIVALENTE AL ULTIMO FLUJO CREADO PARA ESE PROYECTO EN SU ULTIMO NIVEL 
		--HAY QUE TOMAR EL PRIMER ID DEL AREA DEL PRIMER NIVEL DEL FLUJO CATEGORIA CORRESPONDIENTE A NUMREFORM
	select npc.id_departamento into ID_Departamente from
(
select * from 
(select id_flujo ,
    ROW_NUMBER() OVER (PARTITION BY fc.id_categoria ORDER BY fc.fecha_creacion ASC) AS row_num
from flujo_categoria fc 
where fc.id_categoria = (select p.id_categoria from proyectos p where p.id_proyecto=p_id_proyecto)) as X
where X.row_num =(select p.numreforma from proyectos p where p.id_proyecto=p_id_proyecto) ) as Y
inner join niveles_proyecto_categoria npc on Y.id_flujo = npc.id_flujo order by npc.nivel asc limit 1;
	

	/*
	select np.id_departamento into ID_Departamente from 
	(select fp.id_flujo  as idflujo
	from flujo_proyecto fp 
	where fp.id_proyecto =	p_id_proyecto
	order by fp.fecha_creacion desc limit 1) as x 
	inner join niveles_proyecto np on np.id_flujo = X.idflujo order by np.nivel desc limit 1;
	*/
	select jn.id_cabecera into ID_nivel from jerarquias_niveles jn where jn.id_tipo_jerarquia =p_id_tipo_jerarquia order by jn.fecha_creacion desc limit 1;
	--Insertar el primer nivel Elaboracion
	insert into niveles_proyecto(id_departamento,id_flujo,id_nivel,nivel)
	values(ID_Departamente,
	P_id_flujo_new, ID_nivel
	,0);
	--RECORRER EL CURSOR
   open curCopiar;
	fetch next from curCopiar into ID_nivel_c;
	while (Found) loop	
	 select np.id_departamento, np.id_nivel ,np.nivel into ID_Departamente,ID_nivel,Nivel from niveles_proyecto_categoria np where np.id_niveles_pro=ID_nivel_c;
		--esto tiene que insertar el cursor en la tabla
		insert into niveles_proyecto(id_departamento,id_flujo,id_nivel,nivel)
		values(ID_Departamente,P_id_flujo_new,ID_nivel,Nivel);
		--cerrar el cursor 
	fetch curCopiar into ID_nivel_c;
	end loop;
	close curCopiar;
	EXCEPTION
        -- Si ocurre un error en la transacción principal, revertir
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE EXCEPTION 'Ha ocurrido un error en el trigger: %', SQLERRM;
END;
$function$
;



-- DROP PROCEDURE public.publicar_doc(int4);

--Anadir el nuevo algoritmo 
CREATE OR REPLACE PROCEDURE public.publicar_doc(IN p_proyecto_id integer)
 LANGUAGE plpgsql
AS $procedure$
declare
	p_id_estado int;
	p_url_doc varchar(900);
	p_titulo_proyecto varchar(900);
	p_version_p DECIMAL(5, 1);
	p_id_flujo int;
	p_id_area int;
	p_codigo_proyecto varchar(900);
	p_tiene_otro_flujo bool;
	p_categoria int;
	ID_F int =0;
	p_id_departamtento int;
	p_id_nivel int;
	p_nivel int;
	p_id_nivel_flujo int;
	p_primer_nivel int;
	p_ultimo_historial int;
	es_reforma bool;
	peso DECIMAL(5, 1);
	Prefijo_proyect varchar(50);
	Prefijo_area varchar(50);
	Prefijo_categoria varchar(50);
begin
	--seleccionar el id a editar xdxdx Maholy aun no te olvido
	select into p_id_estado en.id_estado 
	from proyectos p 
	inner join flujo_proyecto fp on p.id_proyecto =fp.id_proyecto 
	inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
	inner join estado_nivel en on np.id_niveles_pro = en.id_nivel  
	where p.id_proyecto =p_proyecto_id and en.enviando = false
	order by en.id_estado desc limit 1;
	--editar ese id 
	update estado_nivel set observacion='Se publica el Documento', estado_nivel='Aceptado', enviando=true
      where id_estado = p_id_estado;
     --ahora se tiene que insertar el ultimo documento de ese proyecto en la tabla de publicaciones 
     --primero obtener la url del ultimo documento activo del proyecto mediante el id del proyect 
     select into p_url_doc url_modificado  from documentos_proyectos dp where id_proyecto = p_proyecto_id and estado =true order by id_documento  desc limit 1 ;
	--obtener los datos de la tabla proyecto Titulo, Version , ID flujo
    select p.titulo ,p.versionp into p_titulo_proyecto,p_version_p from proyectos p where p.id_proyecto =p_proyecto_id;
   --obtener el id del ultimo flujo que tiene un proyecto 
   select fp.id_flujo into p_id_flujo from flujo_proyecto fp where fp.id_proyecto = p_proyecto_id order by fp.id_flujo desc limit 1;
  --actualizar el proyecto a estado publicado jsjsjsjs skere modo diablo lol 
  	update proyectos set publicado = true, reforma=true ,documento_preparado=false where id_proyecto =p_proyecto_id;
  --obtener el id del area que elaboro el proyecto xdxd skere modo diablo
  select p.id_area_responsable,p.codigo  into p_id_area,p_codigo_proyecto from proyectos p where p.id_proyecto =p_proyecto_id;
    --ingresar los datos a la tabla jijijij ja
    insert into publicacion_proyecto(url_doc ,id_proyecto,versionp,id_flujo,titulo_publicacion,id_area,codigo) 
   	values (p_url_doc,p_proyecto_id,p_version_p,p_id_flujo,p_titulo_proyecto,p_id_area,p_codigo_proyecto);
	--ingresar los datos al historial de un proyecto ssjsjsj skere modo sjere 
   insert into historial_proyecto (detalle,boton,tipo,id_proyecto,Descripcion, titulo)
	values (concat('El proyecto: ',p_titulo_proyecto, ' se publicó'),false,10,p_proyecto_id,'Se publica el proyecto','Publicación');
	-------PARA PASAR EL PROYECTO AUTOMATICAMENTE A OTRO FLUJO AUTOMATICAMENTE Y HACERLE LA REFORMA
	--	0.-Verificar si la categoria del proyecto tiene flujos y activar lo siguiente
	select case when   COUNT(*)>0 then true else false end as TieneFlujoSIguiente into p_tiene_otro_flujo from 
	(SELECT
    fc.id_flujo,
    fc.id_categoria,
    ROW_NUMBER() OVER (PARTITION BY fc.id_categoria ORDER BY fc.fecha_creacion ASC) AS row_num
	FROM
    flujo_categoria fc
	WHERE
    fc.id_categoria = (select p.id_categoria from proyectos p where p.id_proyecto = p_proyecto_id) AND estado
	ORDER BY
    fc.fecha_creacion asc) as X
	where X.row_num = (select p.numreforma +1 as SiguienteReforma  from proyectos p where p.id_proyecto=p_proyecto_id);

	--SI TIENE AUTOMATIZAR EL PROCESO
	if p_tiene_otro_flujo then 
			--3.-Si se encuentra entonces activar la reforma de ese proyecto(la ultima area del flujo anterior es la que realiza la reforma)
				--3.1.- En el evento reforma Actualizar el numReforma del proyecto sumarle+1 
		call iniciar_reforma_categoria_flujo(p_proyecto_id);
		--4.- Ahora obtener el flujo de la categoria del numReforma
		--5.- Activar el cursor de copiar_niveles_categoria_reformas.
			--como ya se realizo la reforma seleccion el nmreforma nuevo
			select X.id_flujo into p_id_flujo from 
	(SELECT
    fc.id_flujo,
    fc.id_categoria,
    ROW_NUMBER() OVER (PARTITION BY fc.id_categoria ORDER BY fc.fecha_creacion ASC) AS row_num
	FROM
    flujo_categoria fc
	WHERE
    fc.id_categoria = (select p.id_categoria from proyectos p where p.id_proyecto = p_proyecto_id) AND estado
	ORDER BY
    fc.fecha_creacion asc) as X
	where X.row_num = (select p.numreforma   from proyectos p where p.id_proyecto=p_proyecto_id);
	--enviar al cursor p_id_flujo
	--p_id_proyecto integer, p_id_categoria integer, p_id_flujo integer
	--p_categoria
	select p.id_categoria into p_categoria  from proyectos p where p.id_proyecto =p_proyecto_id;
	--CURSOR PARA COPIAR LOS NIVELES
		perform copiar_niveles_categoria_proyecto_reformas(p_proyecto_id,p_categoria,p_id_flujo);
	
	--ahora se necesita registrar el estado del nivel que seria el primero: elaboracion -> 'En elaboracion'
   --para ello primero se toma el ultimo flujo creado del proyecto
   select into p_id_nivel_flujo id_flujo  
	from flujo_proyecto fp
	where fp.id_proyecto =p_proyecto_id and fp.estado =true order by id_flujo desc limit 1;
	--ahora se toma el primer nivel de ese flujo para insertarlo en el estado nivel 
	select into p_primer_nivel id_niveles_pro  from niveles_proyecto np where np.id_flujo = p_id_nivel_flujo and estado =true order by nivel asc limit 1;
	--y se inserta ese p_primer_nivel en los estados del nivel con la observacion -> "EN elaboracion"
	insert into  estado_nivel (id_nivel,observacion,estado_nivel) values (p_primer_nivel, 'Se empieza la elaboracion','Sin enviar');
	--aqui insertar el historial del proyecto cuando se crea un flujo para el proyecto xd

	insert into historial_proyecto (detalle,boton,tipo,id_proyecto,Descripcion, titulo)
	values ('Se crea un nuevo flujo para el proyecto',true,3,p_proyecto_id,'Creación de flujo para el proyecto','Nuevo Flujo');
	--ahora obtener el id de la ultima historia proyecto para conectar ese historial con el flujo 
	--p_ultimo_historial
	select id_historial into  p_ultimo_historial from historial_proyecto hp where hp.id_proyecto =p_proyecto_id order by id_historial desc limit 1;
	--ahora insertar eso en la tabla flujo_historial para empatar el flujo rechazado con el id de la historia 
	insert into historial_flujo(id_flujo,id_historial) values (p_id_nivel_flujo,p_ultimo_historial );
	end if;
	EXCEPTION
        -- Si ocurre un error en la transacción principal, revertir
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE EXCEPTION 'Ha ocurrido un error en la transacción principal: %', SQLERRM;	
END;
$procedure$
;



select * from proyectos p 
--idCategoria = 15

--1.-Obtener el numReforma siguiente del proyecto
--55
--57
select p.numreforma +1 as SiguienteReforma  from proyectos p where p.id_proyecto=55 ;


select case when   COUNT(*)>0 then true else false end as TieneFlujoSIguiente from 
(SELECT
    fc.id_flujo,
    fc.id_categoria,
    ROW_NUMBER() OVER (PARTITION BY fc.id_categoria ORDER BY fc.fecha_creacion ASC) AS row_num
FROM
    flujo_categoria fc
WHERE
    fc.id_categoria = (select p.id_categoria from proyectos p where p.id_proyecto = 57) AND estado
ORDER BY
    fc.fecha_creacion asc) as X
where X.row_num = (select p.numreforma +1 as SiguienteReforma  from proyectos p where p.id_proyecto=57);

select p.numreforma+1  from proyectos p where p.id_proyecto=55;

--Copiar el mismo procedimiento pero sin documento 
-- DROP PROCEDURE public.iniciar_reforma(int4, varchar, int4, varchar);
select * from area_departamental ad where ad.id_area =74;
--p.numreforma+1 

select npc.id_departamento from
(
select * from 
(select id_flujo ,
    ROW_NUMBER() OVER (PARTITION BY fc.id_categoria ORDER BY fc.fecha_creacion ASC) AS row_num
from flujo_categoria fc 
where fc.id_categoria = (select p.id_categoria from proyectos p where p.id_proyecto=55)) as X
where X.row_num =(select p.numreforma+1 from proyectos p where p.id_proyecto=55) ) as Y
inner join niveles_proyecto_categoria npc on Y.id_flujo = npc.id_flujo order by npc.nivel asc limit 1;


CREATE OR REPLACE PROCEDURE public.iniciar_reforma_categoria_flujo
(IN p_id_proyecto integer)
 LANGUAGE plpgsql
AS $procedure$
declare 
	Tiene_Versiones bool;
	Ultima_version_publicada int;
	Prefijo_proyect varchar(50);
	Prefijo_area varchar(50);
	Prefijo_categoria varchar(50);
	Version_actual varchar(50);
	ID_Relacion  int;
	p_nombre_area varchar(900);
	p_titulo varchar (900);
	p_numreform int;
	p_url_alcance character varying;
	p_id_area_reforma int;
Begin
	select case when COUNT(*)>=1 then true else false end as TieneVersiones into Tiene_Versiones from publicacion_proyecto pp where pp.id_proyecto =p_id_proyecto;
	if (Tiene_Versiones)
	then 
	--aqui hacer todo el proceso porque si tiene versiones anteriores publicadas 
	--primero se selecciona la ultima version publicada del proyecto 
		select pp.id_publicacion into Ultima_version_publicada from publicacion_proyecto pp where pp.id_proyecto =p_id_proyecto order by id_publicacion desc limit 1;
	
	select dp.url_doc into p_url_alcance from documentos_proyectos dp where dp.id_proyecto =p_id_proyecto and dp.estado limit 1;
	select p.numreforma+1  into p_numreform from proyectos p where p.id_proyecto=p_id_proyecto;
	--HAY QUE TOMAR EL PRIMER ID DEL AREA DEL PRIMER NIVEL DEL FLUJO CATEGORIA CORRESPONDIENTE A NUMREFORM
	select npc.id_departamento into p_id_area_reforma from
(
select * from 
(select id_flujo ,
    ROW_NUMBER() OVER (PARTITION BY fc.id_categoria ORDER BY fc.fecha_creacion ASC) AS row_num
from flujo_categoria fc 
where fc.id_categoria = (select p.id_categoria from proyectos p where p.id_proyecto=p_id_proyecto)) as X
where X.row_num =p_numreform ) as Y
inner join niveles_proyecto_categoria npc on Y.id_flujo = npc.id_flujo order by npc.nivel asc limit 1;
	
	--ahora si anadir todo el contenido a la tabla reforma y actualizar el proyecto
	insert into reformas(url_alcance,id_publicacion,id_area_reforma,descripcion) values (p_url_alcance,Ultima_version_publicada,p_id_area_reforma,'Ultimo documento publicado');
	--tomar las variables necesarias para poder actualizar la tabla proyectos 
	--armar el codigo del proyecto 
	--create_proyect_prefij
	--lo que necesito para generar el nuevo codigo del proyecto con la version actual sin modificar 
	-- concat(new.prefijo_proyecto,'-', Pref_area,'-',Pref_cat,'-',new.versionp);
	select  p.prefijo_proyecto , cp.prefijo_categoria, p.titulo  into Prefijo_proyect,Prefijo_categoria,p_titulo
	from proyectos p 
	inner join categorias_proyecto cp on p.id_categoria =cp.id_categoria 
	where p.id_proyecto =p_id_proyecto;
	--ahora tomar el prefijo del area xdxd skere modo skere
	select ad.prefijo_departamento into Prefijo_area from area_departamental ad where ad.id_area  = p_id_area_reforma;
	--ahora tomar la ultima version segun el id de la ultima publicacion con dos decimales para formar el novo prefijo jsjsj skere modo skere skere sjere skere 
	select cast(TO_CHAR(pp.versionp, 'FM999D0')as varchar(500)) into Version_actual from publicacion_proyecto pp where pp.id_publicacion =Ultima_version_publicada;
	--ahora actualizar la tabla proyecto
	--obtener el numreforma actual y sumarle 1 y guardarlo en p_numreform
	--actualizar el codigo del area, el id_area , publicado = false 
	update proyectos set codigo=concat(Prefijo_proyect,'-', Prefijo_area,'-',Prefijo_categoria,'-',Version_actual),
						id_area_responsable = p_id_area_reforma, publicado=false,reforma=true, numreforma=p_numreform  where id_proyecto =p_id_proyecto;
	--actualizar el resto de tablas que tengan que ver con el proyecto, como el historial, participantes, flujo, documentos extras, documentos proyecto -5
	update historial_proyecto set estado = false where id_proyecto = p_id_proyecto;
	update participantes set estado = false where id_proyecto = p_id_proyecto;
	update flujo_proyecto set estado = false where id_proyecto =p_id_proyecto;
	update documentos_extras set estado = false where id_proyecto =p_id_proyecto;
	update documentos_proyectos set estado = false where id_proyecto =p_id_proyecto;
	--agregar como participante del proyecto con el rol de admin al administrador de la nueva area encargada del proyecto
	--obtener el id de la realcion 
	select ua.id_relacion into ID_Relacion from usuarios_areas ua where ua.id_area =p_id_area_reforma and rol_area and estado ;
	--insertar los datos en participantes 
	insert into participantes(id_rol,id_relacion_usu_ar,id_proyecto) values(1,ID_Relacion,p_id_proyecto);
	--y agregar al historial del proyecto el mensaje sobre que se esta iniciando una reforma xdxd skere modo skere
	--obtener el nombre del area 
	select ad.nombre_area into p_nombre_area from area_departamental ad where ad.id_area  = p_id_area_reforma;
	insert into historial_proyecto (detalle,boton,tipo,id_proyecto,Descripcion, titulo)
	values (concat('El area: ',p_nombre_area, ' inició la reforma del proyecto : ',p_titulo),false,11,p_id_proyecto,'Se reforma un proyecto','Nueva reforma');
	end if;
	EXCEPTION
        -- Si ocurre un error en la transacción principal, revertir
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE EXCEPTION 'Ha ocurrido un error en la transacción principal: %', SQLERRM;
END;
$procedure$
;

select * from flujo_proyecto fp
inner join niveles_proyecto np ON fp.id_flujo =np.id_flujo 
inner join niveles n on np.id_nivel = n.id_nivel 
where fp.id_proyecto =59;



select * from proyectos fp where fp.id_proyecto =59;

select * from flujo_categoria fc where fc.id_categoria =14;


select * from niveles_estado_proyecto(60);
select * from niveles_estado_proyecto(61);

select * from flujo_proyecto fp
inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
inner join estado_nivel en on np.id_nivel =en.id_nivel 
where fp.id_proyecto = 60;

-- DROP FUNCTION public.niveles_estado_proyecto(int4);

CREATE OR REPLACE FUNCTION public.niveles_estado_proyecto(p_id_proyecto integer)
 RETURNS TABLE(r_id_estado integer, r_estado boolean, r_fecha_estado character varying, r_observacion character varying, r_id_nivel integer, r_estado_nivel character varying, r_id_area integer, r_nombre_area character varying, r_nivel integer, click boolean, r_tipo_nivel character varying)
 LANGUAGE plpgsql
AS $function$
declare
	T_niveles bool;
begin
	select  into T_niveles
	case when count(*)>=1 then true else false end 
	from proyectos p 
	inner join flujo_proyecto fp on p.id_proyecto =fp.id_proyecto 
	inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
	--inner join estado_nivel en on np.id_niveles_pro =en.id_nivel 
	where p.id_proyecto =p_id_proyecto and fp.estado;	
	
	

	--Si es true es porque tiene niveles entonces hay que retornar la data con todo en true 
	if(T_niveles) then
	return query
	select * from
			((	select 
	en.id_estado ,en.estado ,cast(TO_CHAR(en.fecha, 'DD-MON-YYYY') as varchar(500)),en.observacion ,en.id_nivel ,en.estado_nivel,ad.id_area ,ad.nombre_area ,np.nivel, cast(true as bool) ,  n.titulo 
	from proyectos p 
	inner join flujo_proyecto fp on p.id_proyecto =fp.id_proyecto 
	inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
	inner join estado_nivel en on np.id_niveles_pro =en.id_nivel 
	inner join area_departamental ad on np.id_departamento =ad.id_area 
	inner join niveles n on np.id_nivel =n.id_nivel 
	where p.id_proyecto =60 and fp.estado = true order by np.nivel asc )
			union all
			(select 
	0, false, 'Sin fecha', 'Sin enviar',0, 'Sin enviar', ad.id_area ,ad.nombre_area ,np.nivel, cast(true as bool) ,  n.titulo 
	--en.id_estado ,en.estado ,cast(TO_CHAR(en.fecha, 'DD-MON-YYYY') as varchar(500)),en.observacion ,
	--en.id_nivel ,en.estado_nivel,ad.id_area ,ad.nombre_area ,np.nivel, cast(true as bool) ,  n.titulo 
	from proyectos p 
	inner join flujo_proyecto fp on p.id_proyecto =fp.id_proyecto 
	inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
LEFT JOIN estado_nivel en ON np.id_niveles_pro = en.id_nivel -- Cambiado a LEFT JOIN
	inner join area_departamental ad on np.id_departamento =ad.id_area 
	inner join niveles n on np.id_nivel =n.id_nivel 
	where p.id_proyecto =p_id_proyecto  and en.id_nivel IS NULL and fp.estado  order by np.nivel asc ))as x;

	--sino es xq aun esta en elaboracion, entonces retornar data solo con dicho estado
	else 
	return query
			select 
	 cast(0 as int),cast(false as bool),cast(TO_CHAR(p.fecha_creacion, 'DD-MON-YYYY') as varchar(500)),cast('En elaboracion' as varchar(100)),
	 cast(0 as int),cast('No enviado' as varchar(100)),ad.id_area ,ad.nombre_area ,np.nivel , cast(false as bool), n.titulo 
		from proyectos p 
		inner join flujo_proyecto fp ON p.id_proyecto =fp.id_proyecto 
		inner join niveles_proyecto np on fp.id_flujo =np.id_flujo 
		inner join area_departamental ad ON np.id_departamento =ad.id_area 
		inner join niveles n on np.id_nivel =n.id_nivel 
		where p.id_proyecto =p_id_proyecto and fp.estado = true and np.nivel =0 order by np.nivel asc ;	
	end if;
end;
$function$
;

--Arreglar esta funcion porque no esta colocando como en elaboracion el primer nivel xd skere modo Maholy
CREATE OR REPLACE FUNCTION public.categoria_proyecto_flujo()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
---Declarar variables
declare
	Padre_Arbol int;
	is_reforma bool;
	Tiene_flujo bool;
	p_id_flujo int;
	p_p_data JSON;
	ID_F int =0;
	p_id_departamtento int;
	p_id_nivel int;
	p_nivel int;
	p_id_nivel_flujo int;
	p_primer_nivel int;
	p_ultimo_historial int;
	es_reforma bool;
	peso DECIMAL(5, 1);
	Prefijo_proyect varchar(50);
	Prefijo_area varchar(50);
	Prefijo_categoria varchar(50);
begin 
	
	--obtener si el proyecto es reforma
	select p.reforma into is_reforma from proyectos p where p.id_proyecto = new.id_proyecto;
	--id = 14
	--en el trigger omitir ese paso porque el id = new.id_categoria
	--obtener si la categoria tiene por lo menos tiene un flujo
	select case when COUNT(*)>=1 then true else false end into Tiene_flujo from flujo_categoria fc where fc.id_categoria =new.id_categoria;
	--si es true entonces copiar el flujo de la categoria
	--con la misma logica que el de rechazar documento en un nivel hacer esto 
	if Tiene_flujo and not is_reforma then
		--p_id_flujo --> primer flujo de la categoria 
		select fc.id_flujo into p_id_flujo from flujo_categoria fc where fc.id_categoria = new.id_categoria and estado order by fc.fecha_creacion asc limit 1;
	
		--select np.id_niveles_pro  from niveles_proyecto_categoria np  where np.id_flujo =13 and np.estado;
		--13
		--select np.id_niveles_pro  from niveles_proyecto_categoria np  where np.id_flujo =13 and np.estado;
		--Llamar al cursor 
 			PERFORM copiar_niveles_categoria_proyecto(new.id_area_responsable, new.id_proyecto , new.id_categoria ,p_id_flujo);
	end if;
	
   --ahora se necesita registrar el estado del nivel que seria el primero: elaboracion -> 'En elaboracion'
   --para ello primero se toma el ultimo flujo creado del proyecto
   select into p_id_nivel_flujo id_flujo  
	from flujo_proyecto fp
	where fp.id_proyecto =new.id_proyecto and fp.estado =true order by id_flujo asc limit 1;
	--ahora se toma el primer nivel de ese flujo para insertarlo en el estado nivel 
	select into p_primer_nivel id_niveles_pro  from niveles_proyecto np where np.id_flujo = p_id_nivel_flujo and estado =true order by nivel asc limit 1;
	--y se inserta ese p_primer_nivel en los estados del nivel con la observacion -> "EN elaboracion"
	insert into  estado_nivel (id_nivel,observacion,estado_nivel) values (p_primer_nivel, 'Se empieza la elaboracion','Sin enviar');
	--aqui insertar el historial del proyecto cuando se crea un flujo para el proyecto xd

	insert into historial_proyecto (detalle,boton,tipo,id_proyecto,Descripcion, titulo)
	values ('Se crea un nuevo flujo para el proyecto',true,3,new.id_proyecto,'Creación de flujo para el proyecto','Nuevo Flujo');
	--ahora obtener el id de la ultima historia proyecto para conectar ese historial con el flujo 
	--p_ultimo_historial
	select id_historial into  p_ultimo_historial from historial_proyecto hp where hp.id_proyecto =new.id_proyecto order by id_historial desc limit 1;
	--ahora insertar eso en la tabla flujo_historial para empatar el flujo rechazado con el id de la historia 
	insert into historial_flujo(id_flujo,id_historial) values (p_id_nivel_flujo,p_ultimo_historial );
		
return new;
end
$function$
;


select * from guias_proyectos gp ;

--agregar una columa nueva a documentos proyectos para saber la extension del archivo que se subio
select * from documentos_proyectos dp ;

alter table documentos_proyectos 
add column extension_archivo varchar(100) default '.pdf' not null;

-- DROP FUNCTION public.ver_borradores_proyecto(int4);

CREATE OR REPLACE FUNCTION public.ver_borradores_proyecto(p_id_proyecto integer)
 RETURNS TABLE(d_url character varying, d_fecha character varying, d_id integer, d_descripcion character varying, d_extension_archivo character varying)
 LANGUAGE plpgsql
AS $function$
begin
	return query
	select dp.url_doc , cast(TO_CHAR(dp.fecha_creacion, 'DD-MON-YYYY') as varchar(500)),dp.id_documento ,dp.descripcion,dp.extension_archivo from documentos_proyectos dp 
	where id_proyecto = p_id_proyecto and dp.estado =false order by dp.id_documento  asc;	

end;
$function$
;

