const multer = require("multer");
const { dirname, extname, join } = require("path");

const path = require("path");

const urlArchivos = path.join(__dirname, "../../uploads/proyectos");

//const MIMETYPES = ["application/pdf"];
const MIMETYPES = [
  "application/pdf",
  "application/msword", // .doc
  "application/vnd.openxmlformats-officedocument.wordprocessingml.document", // .docx
];

const upload = multer({
  storage: multer.diskStorage({
    destination: urlArchivos,
    filename: (req, file, cb) => {
      const fileExtension = extname(file.originalname);
      const fileName = file.originalname.split(fileExtension)[0];
      cb(null, `${fileName}-${Date.now()}${fileExtension}`);
    },
  }),

  fileFilter: (req, file, cb) => {
    if (MIMETYPES.includes(file.mimetype)) cb(null, true);
    else cb(new Error("Only " + MIMETYPES.join("") + " son permitidos"));
  },
});
module.exports = {
  upload,
};
