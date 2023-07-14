//aqui van las funciones del modulo proyecto 
const pool = require('../../db');
const fs = require('fs');




let ipFileServer = "../../uploads/proyectos/";
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

        const { file } = req;
        const documento = `${ipFileServer}${file?.filename}`;


        const users = await pool.query('call documento_proyecto($1,$2)', [documento, id]);
        console.log(users);
        return res.status(200).json({ message: "se subio el archivo" });
    } catch (error) {
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

        const users = await pool.query('select * from proyectos_areas($1)', [id]);
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
    estado_categoria
};
