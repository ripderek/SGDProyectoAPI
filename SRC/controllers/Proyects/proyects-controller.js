//aqui van las funciones del modulo proyecto 
const pool = require('../../db');
const fs = require('fs');

let ipFileServer = "../../uploads/proyectos/";
const { extname } = require('path');
const path = require('path');


const crear_proyecto = async (req, res, next) => {
    try {
        const { p_titulo, p_id_area, p_id_categoria, p_prefijo_proyecto, p_subir_docs } = req.body;
        const users = await pool.query('call crear_proyecto($1,$2,$3,$4,$5)', [p_titulo, p_id_area, p_id_categoria, p_prefijo_proyecto, p_subir_docs]);
        console.log(users);
        return res.status(200).json({ message: "Se creo el proyecto" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}

const editar_categoria = async (req, res, next) => {
    try {
        const { p_nombres, p_prefijo, p_descripcion, p_id_categoria } = req.body;
        const users = await pool.query('call Editar_Categoria($1,$2,$3,$4)', [p_nombres, p_prefijo, p_descripcion, p_id_categoria]);
        console.log(users);
        return res.status(200).json({ message: "Se creo edito la categoria" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}

const subir_pdf = async (req, res, next) => {
    try {
        const { id } = req.body;
        const { descripcion } = req.body;
        const { file } = req;
        const documento = `${ipFileServer}${file?.filename}`;
        console.log(descripcion);

        const users = await pool.query('call documento_proyecto($1,$2,$3)', [documento, id, descripcion]);
        console.log(users);
        return res.status(200).json({ message: "se subio el archivo" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}



const crear_categoria = async (req, res, next) => {
    try {
        const { p_nombre, p_prefijo, p_descripcion } = req.body;
        const users = await pool.query('call crear_categoria_proyecto($1,$2,$3)', [p_nombre, p_prefijo, p_descripcion]);
        console.log(users);
        return res.status(200).json({ message: "Se creo la categoria" });
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
const estado_categoria = async (req, res, next) => {
    try {
        const { id } = req.params;
        const users = await pool.query('call Estado_Categoria($1)', [id]);
        console.log(users);
        return res.status(200).json({ message: "Se edito el estado de  la categoria" });
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
const proyectos_areas = async (req, res, next) => {
    try {
        const { id } = req.params;
        const { id2 } = req.params;

        const users = await pool.query('select * from proyectos_areas($1,$2)', [id, id2]);
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
const all_categorias = async (req, res, next) => {
    try {
        const users = await pool.query('select * from categorias_proyectos()');
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}

const list_categorias = async (req, res, next) => {
    try {
        const users = await pool.query('select * from Lis_categorias()');
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}

const roles_proyecto = async (req, res, next) => {
    try {
        const { p_id_user, p_id_proyect } = req.body;
        const users = await pool.query('select * from rol_proyecto($1,$2)', [p_id_user, p_id_proyect]);
        console.log(users);
        return res.status(200).json(users.rows[0]);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}

const documentos_proyectos = async (req, res, next) => {
    try {
        const { id } = req.params;
        const users = await pool.query('select * from ver_docs($1)', [id]);
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}

const ver_pdf = async (req, res) => {
    try {
        const { id } = req.params;

        const users = await pool.query('select * from ver_docs_x_id($1)', [id]);
        const urlArchivos = path.join(__dirname, "../" + users.rows[0].d_url)

        var data = fs.readFileSync(urlArchivos);
        res.contentType("application/pdf");
        res.send(data);
    } catch (error) {
        return res.status(404).json({ message: error.message });

    }
}

const guias_proyectos = async (req, res, next) => {
    try {
        const { id } = req.params;
        const users = await pool.query('select * from List_Guias_proyectos($1)', [id]);
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}

//Nuevo agregado desde la pc de Herrera
let ipFileServerGuia = "../../uploads/Guias/";

const subir_guia = async (req, res, next) => {
    try {
        const { id } = req.body;

        const { file } = req;
        const documento = `${ipFileServerGuia}${file?.filename}`;

        //let ext = path.extname(file);

        const { descripcion } = req.body;
        console.log(documento);


        const extension = extname(file.originalname);
        const ext = file.originalname.split(extension)[1];

        console.log(extension);
        console.log(ext);
        console.log("aqui se envia el archivo");
        // console.log(id,documento,ext.substr(1),descripcion);

        const users = await pool.query('call subir_guia($1,$2,$3,$4)', [documento, id, extension, descripcion]);
        console.log(users);

        return res.status(200).json({ message: "se subio el archivo" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}

const download_guia = async (req, res) => {
    console.log("descargar guia");
    try {
        const { link } = req.body;

        const urlArchivos = path.join(__dirname, "../" + link)

        console.log(urlArchivos);
        return res.download(urlArchivos);

        //res.download( link);
        //console.log(link);
        //return res.status(200).json({ message: "se descarga el archivo" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}

const ver_flujo_proyecto = async (req, res, next) => {
    try {
        const { id } = req.params;
        const users = await pool.query('select * from ver_FLujo_Proyecto($1)', [id]);
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}

const borradores_proyecto = async (req, res, next) => {
    try {
        const { id } = req.params;
        const users = await pool.query('select * from ver_borradores_proyecto($1)', [id]);
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}

const proyect_data = async (req, res, next) => {
    try {
        const { id } = req.params;
        const users = await pool.query('select * from data_proyect($1)', [id]);
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}

const niveles_estado = async (req, res, next) => {
    try {
        const { id } = req.params;
        const users = await pool.query('select * from niveles_estado_proyecto($1)', [id]);
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}

const ver_flujo_proyecto_nivel2 = async (req, res, next) => {
    try {
        const { id } = req.params;
        const users = await pool.query('select * from ver_FLujo_Proyecto_nivel2($1)', [id]);
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}

const subir_primer_nivel = async (req, res, next) => {
    try {
        const { list_niveles } = req.body;
        const users = await pool.query('call subir_primer_nivel($1)', [JSON.stringify(list_niveles)]);
        return res.status(200).json({ message: "Se subio de nivel el proyecto" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}


module.exports = {
    crear_proyecto,
    crear_categoria,
    proyectos_areas,
    all_categorias,
    roles_proyecto,
    subir_pdf,
    documentos_proyectos,
    ver_pdf,
    list_categorias,
    editar_categoria,
    estado_categoria,
    guias_proyectos,
    subir_guia,
    download_guia,
    ver_flujo_proyecto,
    borradores_proyecto,
    proyect_data,
    niveles_estado,
    ver_flujo_proyecto_nivel2,
    subir_primer_nivel
};
