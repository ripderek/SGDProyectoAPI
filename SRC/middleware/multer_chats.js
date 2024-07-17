const multer = require('multer');
const { dirname, extname, join } = require('path');

const path = require('path');


const urlArchivos = path.join(__dirname, "../../uploads/chats")

const MIMETYPES = ['image/jpeg', 'image/png'];

const upload = multer({
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
        else cb(new Error('Only ' + MIMETYPES.join('') + 'son permitidos'))
    },
    limits: {
        fieldSize: 10000000,
    }
});
module.exports = {
    upload
};