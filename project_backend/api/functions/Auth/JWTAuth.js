const jwt = require('jsonwebtoken');

export const createToken = (user) => {

    return jwt.sign(user, process.env.TOKEN_SECRET);
};


export const verifyToken = (headerToken) => {
    // const token = headerToken && headerToken.split(' ')[1]
    if (headerToken === null || headerToken === undefined || headerToken === "") return null; // if there isn't any token
    try {
        var user = jwt.verify(headerToken, process.env.TOKEN_SECRET);
        return user;
    } catch (err) {
        return "error";
    }

};