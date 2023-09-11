const multer = require('multer');
const { dirname, extname, join } = require('path');

const path = require('path');


const urlArchivos = path.join(__dirname, "../../uploads/proyectos_firmas")

const MIMETYPES = ['application/pdf'];

const upload_firma = multer({
    storage: multer.diskStorage({
        destination: urlArchivos,
        filename: (req, file, cb) => {
            const fileExtension = extname(file.originalname);
            const fileName = file.originalname.split(fileExtension)[0];
            cb(null, `${fileName}-${Date.now()}${fileExtension}`);
        }
    }),

    fileFilter: (req, file, cb) => {
        if (MIMETYPES.includes(file.mimetype)) cb(null, true)
        else cb(new Error('Only application/pdf son permitidos'))
    }
});
module.exports = {
    upload_firma
};