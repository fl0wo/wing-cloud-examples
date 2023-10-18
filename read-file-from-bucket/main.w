bring cloud;
bring http;

// 👇 We create a bucket with a file inside
let bucket = new cloud.Bucket();
bucket.addObject("file1.txt", "My file content!!");

// 👇 Here we have the Api Gateway
let api = new cloud.Api();

// 👇 Let's create an endpoint for HTTP get requests
api.get("/read-file/{fileName}", inflight (req: cloud.ApiRequest): cloud.ApiResponse => {
  let fileName = req.vars.get("fileName");
  let items = bucket.list();

  // 👇 If the bucket do not contain the file name
  if (!items.contains(fileName)) {
    return cloud.ApiResponse {
      status: 404,
      body: "File not found"
    };
  }

  // 👇 Otherwise we can safely read it
  return cloud.ApiResponse {
    status: 200,
    body: bucket.get(fileName)
  };
});