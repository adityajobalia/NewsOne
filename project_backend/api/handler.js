'use strict';

export const hello = async event => {

    let quizData = [
        {
            question: "Main Campus of Conestoga College?", options:["Doon Vally","Waterloo","Cambridge","Downtown"], answer: 1,level : 1
        },
        {
            question : "How many campus does Conestoga college Have?",options: ["5","9","13","17"],answer: 2,level:1
        },{
            question : "In which campus Mobile Solution development Course is Offered ?",options: ["Doon Valley","DownTown","Waterloo","Cambridge"],answer: 3,level:1
        },
        {
            question: "What is the capital of the United States of America?", options:["New York","Washington, D.C.","Philadelphia","Baltimore"], answer: 2,level:2
        },{
            question : "How many countries are in Europe?",options: ["27","51","10","44"],answer: 4,level:2
        },{
            question : "How many wonders world have?",options: ["7","8","6","9"],answer: 1,level:2
        },{
            question: "Who invented thermometer?", options:["James Watson","Thomas Allbut","Galileo","Alexander Graham Bell"], answer: 2,level : 3
        },{
            question : "Which is the biggest city in the world?",options: ["New York","Wuhan","Istanbul","Tokyo"],answer: 4,level : 3
        },{
            question : "Biggest country in the world ?",options: ["Russia","China","Canada","France"],answer: 1,level : 3
        },
        {
            question: "FIFA was founded in which country?", options:["Italy","France","England","Spain"], answer: 2,level : 4
        },{

            question : "For which of the following sports the famous “Golden Ball Award” is presented?",options: ["Cricket","Hockey","Tennis","Football"],answer: 4,level:4
        },{

            question : "What is the hottest continent on Earth?",options: ["Asia","Africa","Europe","Australia"],answer: 2,level : 4
        },{
            question: "What is the official language of Brazil?", options:["French","Spanish","Talian","Portuguese"], answer: 4,level : 5
        },{

            question : "What chemical element is diamond made of?",options: ["Carbon","Helium","Lead","Copper"],answer: 1,level : 5
        },{
            question : "Radius of Earth (in Km) ?",options: ["6359","6375","6371","6351"],answer: 3,level : 5
        }
    ]

    return {
        statusCode: 200,
        body: JSON.stringify(quizData,
            null,
            2
        ),
    };

    // Use this code if you don't use the http event with the LAMBDA-PROXY integration
    // return { message: 'Go Serverless v1.0! Your function executed successfully!', event };
};

















