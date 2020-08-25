import { getAllData } from "../../Database/scan";
import { readData } from "../../Database/read";
import { verifyToken } from "../Auth/JWTAuth";

export const fetchNewsDB = async (event, context, callback) => {
  try {
    let userDataBody = JSON.parse(event.body);
    let user = verifyToken(userDataBody.authToken);
    if (user === null || user === "error") {
      return {
        statusCode: 401,
        body: JSON.stringify({
          code: -5,
          data: {
            news: {},
            authToken: event.headers["authToken"],
          },
          message: "Invalid Auth Token",
        }),
      };
    }

    var topics = user.topics;
    var topicList = [];

    topics = topics.replace("[", "");
    topics = topics.replace("]", "");
    topicList = topics.split(",");
    topicList = topicList.map((topic) => {
      return topic.trim();
    });

    var params = {
      TableName: process.env.News,
    };
    let allNews = await getAllData(params);
    var filteredNews = [];

    filteredNews = filterNews(allNews.Items, topicList);

    return {
      statusCode: 200,
      body: JSON.stringify({
        code: 0,
        data: {
          News: filteredNews
       
        },
        message: "All News Retrieved",
      }),
    };
  } catch (e) {
    return {
      statusCode: 501,
      body: JSON.stringify({
        code: -1,
        data: {
          News: {},
        },
        message: e.message,
      }),
    };
  }
};

export const getNewsById = async (event, context, callback) => {
  try {
    let params = {
      TableName: process.env.News,
      Key: {
        newsid: event.pathParameters.newsid,
      },
    };

    let result = await readData(params);
    return {
      statusCode: 200,
      body: JSON.stringify({
        code: 0,
        data: result.Item,
        message: "Specific News Retrieved",
      }),
    };
  } catch (e) {
    return {
      statusCode: 501,
      body: JSON.stringify({
        code: 0,
        data: {},
        message: e.message,
      }),
    };
  }
};

export const filterNews = (allNews, topics) => {
  let filteredNews = [];
  if (topics[0] == "") {
    return allNews;
  }
  for (let i = 0; i < allNews.length; i++) {
    if (topics.indexOf(allNews[i].category) > -1) {
      filteredNews.push(allNews[i]);
    }
  }

  return filteredNews;
};
