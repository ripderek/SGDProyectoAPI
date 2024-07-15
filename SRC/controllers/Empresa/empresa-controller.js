const pool = require("../../db");
const path = require("path");
const fs = require("fs");

//directorio de los perfiles
let ipFileServer = "../../uploads/perfiles/";

const modificar_empresa = async (req, res, next) => {
  try {
    const {
      nombres_empresa,
      direccion_empresa,
      celular_empresa,
      correo_empresa,
    } = req.body;
    const { id } = req.params;

    const users = await pool.query("call Editar_Empresa($1,$2,$3,$4,$5)", [
      nombres_empresa,
      direccion_empresa,
      celular_empresa,
      correo_empresa,
      id,
    ]);
    console.log(users);
    return res.status(200).json({ message: "Se edito la empresa" });
  } catch (error) {
    return res.status(404).json({ message: error.message });
  }
};

const datos_Empresa = async (req, res, next) => {
  try {
    const users = await pool.query("select * from empresa_Data()");
    console.log(users);
    return res.status(200).json(users.rows[0]);
  } catch (error) {
    next(error);
  }
};
const ver_word = async (req, res) => {
  try {
    const { id } = req.params;
    const users = await pool.query("select * from ver_docs_x_id($1)", [id]);
    const urlArchivos = path.join(__dirname, "../" + users.rows[0].d_url);
    var data = fs.readFileSync(urlArchivos);
    res.contentType(
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    );

    res.send(data);
  } catch (error) {
    return res.status(404).json({ message: error.message });
  }
};
const imagen_empresa = async (req, res, next) => {
  try {
    const users = await pool.query("select * from empresa_URl()");
    let ext = path.extname("7.jpg");
    let fd = fs.createReadStream(
      path.join(__dirname, "../" + users.rows[0].url_foto)
    );
    res.setHeader("Content-Type", "image/" + ext.substr(1));
    fd.pipe(res);
  } catch (error) {
    return res.status(404).json({ message: "No se encuentra la imagen " });
  }
};
const cambiar_foto = async (req, res, next) => {
  try {
    //file de la foto
    const { file } = req;
    const foto = `${ipFileServer}${file?.filename}`;
    //crear el user en la BD
    const { id_empresa } = req.body;
    const users = await pool.query("Call Cambiar_Foto_Empresa($1,$2)", [
      foto,
      id_empresa,
    ]);

    console.log(foto + id_empresa);

    return res.status(200).json({ message: "Se cambio la foto" });
  } catch (error) {
    return res.status(404).json({ message: error.constraint });
  }
};

module.exports = {
  modificar_empresa,
  datos_Empresa,
  imagen_empresa,
  cambiar_foto,
  ver_word,
};
