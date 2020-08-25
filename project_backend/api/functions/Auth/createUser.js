import { createRecord } from "../../Database/create";
import { createToken } from "./JWTAuth";
export const createNewUser = async (event, context, callback) => {
  try {
    let userDataBody = JSON.parse(event.body);
    const timestamp = new Date().toUTCString();
    let userParams = {
      TableName: process.env.Users,
      Item: {
        userid: userDataBody.userid,
        city: userDataBody.city,
        topics: userDataBody.topics,
        displayName: userDataBody.displayName,
        email: userDataBody.email,
        imageURL: userDataBody.imageURL,
        firebaseToken: userDataBody.firebaseToken,
        createdAt: timestamp,
        loginUsing: userDataBody.loginUsing,
      },
    };

    console.log(userParams);
    let dbRecord = await createRecord(userParams);
    if (dbRecord) {
      let jwtToken = createToken({
        userid: userParams.Item.userid,
        topics: userDataBody.topics,
      });
      return {
        statusCode: 200,
        body: JSON.stringify({
          code: 0,
          data: {
            statusCode: 0,
            statusDesc: "User Added Successfully.",
            jwtToken,
          },
          message: "User Added Successfully.",
        }),
      };
    } else {
      return {
        statusCode: 200,
        body: JSON.stringify({
          code: 0,
          data: {
            statusCode: -1,
            statusDesc: "Problem while creating user.",
            jwtToken: "",
          },
          message: "Problem while creating user",
        }),
      };
    }
  } catch (err) {
    return {
      statusCode: 501,
      body: JSON.stringify({
        code: -1,
        data: {},
        message: err.message,
      }),
    };
  }
};
