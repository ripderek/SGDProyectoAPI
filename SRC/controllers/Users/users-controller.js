const pool = require('../../db');
const path = require('path');
const fs = require('fs');
const nodemailer = require('nodemailer');
const jwt = require('jsonwebtoken');


//directorio de los perfiles 
let ipFileServer = "../../uploads/perfiles/";


const crear_usuario = async (req, res, next) => {
    try {

        //file de la foto
        const { file } = req
        const foto = `${ipFileServer}${file?.filename}`;
        //crear el user en la BD
        const { nombres } = req.body;
        const { tipo_identificacion } = req.body;
        const { identificacion } = req.body;
        const { correo1 } = req.body;
        const { correo2 } = req.body;
        const { celular } = req.body;
        const { firma } = req.body;
        const { isadmin } = req.body;
        const users = await pool.query('Call Crear_Usuario($1,$2,$3,$4,$5,$6,$7,$8,$9)', [nombres, tipo_identificacion, identificacion, correo1, correo2, celular, foto, firma, isadmin]);
        console.log(users);

        //Llamar a la funcion que enviar el correo
        enviarMail(nombres, identificacion, correo2);

        return res.status(200).json({ message: "Se creo el usuario" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}


const crear_usuario_area = async (req, res, next) => {
    try {

        //file de la foto
        const { file } = req
        const foto = `${ipFileServer}${file?.filename}`;
        //crear el user en la BD
        const { nombres } = req.body;
        const { tipo_identificacion } = req.body;
        const { identificacion } = req.body;
        const { correo1 } = req.body;
        const { correo2 } = req.body;
        const { celular } = req.body;
        const { firma } = req.body;
        const { id_area } = req.body;

        //console.log("Eeste es el rol" + rol);


        const users = await pool.query('Call Crear_Usuario_area($1,$2,$3,$4,$5,$6,$7,$8,$9)', [nombres, tipo_identificacion, identificacion, correo1, correo2, celular, foto, firma, id_area]);
        console.log(users);

        //Llamar a la funcion que enviar el correo
        enviarMail(nombres, identificacion, correo2);

        return res.status(200).json({ message: "Se creo el usuario" });

    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}



const modificar_usuario = async (req, res, next) => {
    try {
        const { nombres, tipoidentifiacion, identificacion, correo1, correo2, celular, firma } = req.body;
        const { id } = req.params;

        const users = await pool.query('call Editar_Usuario($1,$2,$3,$4,$5,$6,$7,$8)', [nombres, tipoidentifiacion, identificacion, correo1, correo2, celular, firma, id]);
        console.log(users);
        return res.status(200).json({ message: "Se edito el usuario" });
    } catch (error) {
        return res.status(404).json({ message: error.message });

    }
}

const modificar_usuario_not_admin = async (req, res, next) => {
    try {
        const { nombres, tipoidentifiacion, identificacion, correo1, correo2, celular, firma } = req.body;
        const { id } = req.params;

        const users = await pool.query('call Editar_Usuario_not_admin($1,$2,$3,$4)', [correo1, celular, firma, id]);
        console.log(users);
        return res.status(200).json({ message: "Se edito el usuario" });
    } catch (error) {
        return res.status(404).json({ message: error.message });

    }
}

const datos_Usuarios = async (req, res, next) => {
    try {
        const { id } = req.params;

        const users = await pool.query('select * from User_Data($1)', [id]);
        console.log(users);
        return res.status(200).json(users.rows[0]);
    } catch (error) {
        next(error);
    }
}

//Listas los uarios usando la paginacion
const all_data_users = async (req, res, next) => {
    try {
        const { pag } = req.params;
        const users = await pool.query('select * from users_paginacion($1)', [pag]);
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        next(error);
    }
}

//La cantidad de paginas que se pueden mostrar del usuario
const total_pag_users = async (req, res, next) => {
    try {
        const users = await pool.query('select * from users_total_paginacion()');
        const totalPaginas = users.rows[0].r_total_paginas;
        console.log(totalPaginas);
        return res.status(200).json({ totalPaginas });
    } catch (error) {
        next(error);
    }
}

//COnsulta para ver los perfiles de los usuarios 
const imagen_user = async (req, res, next) => {
    try {
        const { id } = req.params;
        const users = await pool.query('select * from User_Perfil($1)', [id]);
        let ext = path.extname("7.jpg");
        let fd = fs.createReadStream(path.join(__dirname, "../" + users.rows[0].url_foto_user));
        res.setHeader("Content-Type", "image/" + ext.substr(1));
        fd.pipe(res);
    } catch (error) {
        return res.status(404).json({ message: "No se encuentra la imagen " });
    }
    //res.download('SRC/Assets/Wallpaper/Fri7zeuWIAA8Z7m.jpg'); para descargar xd 
}

const datos_usuario = async (req, res, next) => {
    try {
        const { id } = req.params;
        const users = await pool.query('select * from data_user_p($1)', [id]);
        console.log(users);
        return res.status(200).json(users.rows[0]);
    } catch (error) {
        next(error);
    }
}

const cambiar_foto = async (req, res, next) => {
    try {

        //file de la foto
        const { file } = req
        const foto = `${ipFileServer}${file?.filename}`;
        //crear el user en la BD
        const { id_user } = req.body;

        const users = await pool.query('Call Cambiar_Foto($1,$2)', [foto, id_user]);
        console.log(id_user + foto);
        return res.status(200).json({ message: "Se cambio la foto" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.constraint });
    }
}
const actualizar_contrasena = async (req, res, next) => {
    try {
        const { contra_nueva, contra_nueva1, contra_actual, id } = req.body;
        if (contra_nueva === contra_nueva1) {
            //primero verificar si la contrase actual y el id coinciden 
            const verific = await pool.query('select * from verficiar_contrasena_id($1,$2)', [contra_actual, id]);
            console.log(verific);

            if (verific.rowCount === 0)
                return res.status(404).json({ message: "La contrasena alctual no coincide" });
            else { const users = await pool.query('call cambiar_contra($1,$2,$3)', [contra_nueva, contra_actual, id]); }

            // const users = await pool.query('call cambiar_contra($1,$2,$3)', [contra_nueva, contra_actual, id]);
            //console.log('Aqui va el cambio de contra');
            return res.status(200).json({ message: "Se edito el usuario" });
        } else {
            return res.status(404).json({ message: "Las contrasenas no coinciden" });
        }

    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });

    }
}


const actualizar_contrasena_admin = async (req, res, next) => {
    try {
        const { contra_nueva, contra_nueva1, id } = req.body;
        if (contra_nueva === contra_nueva1) {
            const users = await pool.query('call Cambiar_Contra_admin($1,$2)', [contra_nueva, id]);
            return res.status(200).json({ message: "Se edito el usuario" });
        } else {
            return res.status(404).json({ message: "Las contrasenas no coinciden" });
        }

    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });

    }
}


const deshabilitar_usuario = async (req, res, next) => {
    try {
        const { id } = req.params;
        console.log("CambiarEstado user");
        console.log(id);
        const users = await pool.query('call Deshabilitar_Usuario($1)', [id]);
        console.log(users);
        return res.status(200).json({ message: "Se Deshabilito el usuario" });
    } catch (error) {
        console.log("este es el error");
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}

//Funcion que envia un correo eletronico 
const enviarMail = async (name, iden, correo) => {
    try {

        console.log('aqui estan los datos pasados', iden, correo)

        const users = await pool.query('select * from contra_user($1,$2)', [iden, correo]);
        console.log(users.rows[0].contras);
        const contra_user = users.rows[0].contras;

        const config = {
            host: 'smtp.gmail.com',
            port: 587,
            auth: {
                user: process.env.USER_APLICATION_GMAIL,
                pass: process.env.PASSWOR_APLICATION_GMAIL
            }
        }

        const mensaje = {
            from: process.env.USER_APLICATION_GMAIL,
            to: correo,
            subject: 'SGDV: Contraseña de acceso',
            html: `
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Correo de Acceso</title>
            </head>
            <body style="font-family: Arial, sans-serif; margin: 0; padding: 0;">
                <div style="background-color: #f4f4f4; padding: 20px;">
                    <div style="background-color: #ffffff; max-width: 600px; margin: 0 auto; border-radius: 10px; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);">
                        <div style="text-align: center; padding: 15px;">
                            <h1 style="color: #333;">SGDV</h1>
                        </div>
                        <div style="padding: 20px;">
                            <p style="font-weight: bold">¡Hola! ${name}</p>
                            <p>¡Bienvenido al SGDV!</p>
                            <p>Esta es su clave para iniciar sesión. No se olvide de cambiarla una vez que inicie sesión por primera vez:</p>
                            <div style="text-align: center;">
                                <p style="font-weight: bold; font-size: 18px; color: #333;">${contra_user}</p>
                            </div>
                        </div>
                        <div style="text-align: center; background-color: #333; padding: 10px 0; color: #fff; border-bottom-left-radius: 10px; border-bottom-right-radius: 10px;">
                            <p style="margin: 0;">© 2023 SGDV. Todos los derechos reservados.</p>
                        </div>
                    </div>
                </div>
            </body>
            </html>
        `
        }

        const transport = nodemailer.createTransport(config);

        const info = await transport.sendMail(mensaje);

        console.log('aqui esta las info', info);

    } catch (error) {
        console.log('aqui da un error: ', error);
    }
}

const JWT_SECRET = 'SOME SUPER SECRET...';

const recuperar_cuenta = async (req, res, next) => {
    try {

        const { correo } = req.body;

        const users = await pool.query('select * from recuperar_cuenta_verificar($1)', [correo]);

        let verification = users.rows[0];

        //Extraer el resultado del bool para saber si se encontro el correo
        let result = verification.verification;
        console.log('The result is:' + result);

        //Si no encontro el correo decir es diferente del estado 1
        if (result != 1) return res.status(401).json({ error: verification.mensaje });

        //Extraer la contraseña actual que tiene y enviarla en el token
        const users2 = await pool.query('select * from contra_user_token($1)', [correo]);
        console.log(users2.rows[0].contrat);
        const contra_user = users2.rows[0].contrat;


        const secret = JWT_SECRET + correo;
        const payload = {
            email: correo,
            ucontra: contra_user
        };
        const token = jwt.sign(payload, secret, { expiresIn: '5m' });
        //const encodedToken = encodeURIComponent(token);
        const resetLink = `http://localhost:3000/resetpassword/${correo}*${token}`;


        // Configurar nodemailer para enviar correos electrónicos
        const transporter = nodemailer.createTransport({
            service: 'gmail',
            auth: {
                user: process.env.USER_APLICATION_GMAIL, // Reemplaza con tu dirección de correo electrónico de Gmail
                pass: process.env.PASSWOR_APLICATION_GMAIL // Reemplaza con tu contraseña de correo electrónico de Gmail
            }
        });

        transporter.sendMail({
            from: process.env.USER_APLICATION_GMAIL, // Reemplaza con la dirección de correo electrónico desde la cual deseas enviar el correo
            to: correo, // Reemplaza con la dirección de correo electrónico del destinatario obtenida de la base de datos
            subject: 'SGDV: Recuperar cuenta', // Asunto del correo electrónico
            html:
                `
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Correo de Acceso</title>
            </head>
            <body style="font-family: Arial, sans-serif; margin: 0; padding: 0;">
                <div style="background-color: #f4f4f4; padding: 20px;">
                    <div style="background-color: #ffffff; max-width: 600px; margin: 0 auto; border-radius: 10px; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);">
                        <div style="text-align: center; padding: 15px;">
                            <h1 style="color: #333;">SGDV</h1>
                        </div>
                        <div style="padding: 20px;">
                            <p style="font-weight: bold">¡Hola!</p>
                            <p>¡Bienvenido al SGDV!</p>
                            <p>Haz solicitado la recuperacion de cuenta, si nos solicitado esto, cambia la contraseña</p>
                            <p>Haz clic en el siguiente enlace para restablecer tu contraseña:</p>
                            <div style="text-align: center;">
                                <a href="${resetLink}">${resetLink}</a>
                            </div>
                        </div>
                        <div style="text-align: center; background-color: #333; padding: 10px 0; color: #fff; border-bottom-left-radius: 10px; border-bottom-right-radius: 10px;">
                            <p style="margin: 0;">© 2023 SGDV. Todos los derechos reservados.</p>
                        </div>
                    </div>
                </div>
            </body>
            </html>
        `
        }, (error, info) => {
            if (error) {
                console.log('Error al enviar el correo electrónico:', error);
            } else {
                console.log('Correo electrónico enviado:', info.messageId);
            }
        });


        //Si todo salio bien se envia un mensaje que todo salio bien
        return res.status(200).json({ message: verification.mensaje });

    } catch (error) {
        console.log("este es el error");
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}

const recuperar_cuenta_contrasena = async (req, res, next) => {
    try {
        const { contra1, contra2, correo, tokena } = req.body;
        if (contra1 === contra2) {

            const secret2 = JWT_SECRET + correo;
            const payload2 = jwt.verify(tokena, secret2);

            if (contra1 === payload2.ucontra) {
                return res.status(404).json({ message: "Ingrese otra contraseña por favor" });
            }

            // consultar la contraseña actual, la cambiada 
            const users2 = await pool.query('select * from contra_user_token($1)', [correo]);
            const contra_user = users2.rows[0].contrat;
            console.log('nueva', contra_user);
            console.log('vieja', payload2.ucontra);


            //Comparar la contraseña que saco aqui con la que pase por el token.

            if (payload2.ucontra !== contra_user) {
                return res.status(404).json({ message: "El token no es valido, cierre la ventana por favor" });
            }

            const users = await pool.query('call recuperar_cuenta_contra($1,$2)', [contra1, correo]);

            return res.status(200).json({ message: "Contraseña guardada" });

        } else {
            return res.status(404).json({ message: "Las contrasenas no coinciden" });
        }

    } catch (error) {

        if (error.name === 'JsonWebTokenError' && error.message === 'invalid signature') {
            return res.status(404).json({ message: "Token invalido, por favor solicite uno nuevo" });
        }
        if (error.name === 'TokenExpiredError' && error.message === 'jwt expired') {
            return res.status(404).json({ message: "El token a expirado,por favor solicite uno nuevo" });
        }
        console.log(error);
        return res.status(404).json({ message: error.message });

    }
}


const rol_usuario = async (req, res, next) => {
    try {
        const { idu, p_id_proyecto, p_id_area} = req.body;

        const users = await pool.query('select * from user_data_rol($1,$2,$3)', [idu,p_id_proyecto,p_id_area]);
        console.log(users);
        return res.status(200).json(users.rows[0]);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}

module.exports = {
    crear_usuario,
    modificar_usuario,
    datos_Usuarios,
    all_data_users,
    imagen_user,
    datos_usuario,
    cambiar_foto,
    actualizar_contrasena,
    crear_usuario_area,
    actualizar_contrasena_admin,
    deshabilitar_usuario,
    modificar_usuario_not_admin,
    recuperar_cuenta,
    recuperar_cuenta_contrasena,
    total_pag_users,
    rol_usuario
};
