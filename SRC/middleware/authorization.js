const jwt = require('jsonwebtoken');

function authenticateToken(req, res, next) {
    const { myTokenName } = req.cookies;
    if (myTokenName == null) return res.status(401).json({ error: "Null Token" });
    jwt.verify(myTokenName, 'SECRET', (error, user) => {
        if (error) return res.status(403).json({ error: error.message });
        req.user = user;
        next();
    })
}

//EL SECRET DEBE ESTAR EN UN .ENV
//export { authenticateToken };

module.exports = {
    authenticateToken
};