const fs = require("fs");

module.exports = async (page, scenario) => {
  let cookies = [];
  const cookiePath = scenario.cookiePath || 'config/cookies.json';

  // READ COOKIES FROM FILE IF EXISTS
  if (fs.existsSync(cookiePath)) {
    cookies = JSON.parse(fs.readFileSync(cookiePath));
  } else {
    console.log("Failed to load cookies from: ", cookiePath);
  }

  // MUNGE COOKIE DOMAIN
  // NOPE DO NOT
  /**
  cookies = cookies.map((cookie) => {
    if (
      cookie.domain.startsWith("http://") ||
      cookie.domain.startsWith("https://")
    ) {
      cookie.url = cookie.domain;
    } else {
      cookie.url = "https://" + cookie.domain;
    }
    delete cookie.domain;
    return cookie;
  });
  */

  // SET COOKIES
  const setCookies = async () => {
    return Promise.all(
      cookies.map(async (cookie) => {
        await page.setCookie(cookie);
      })
    );
  };
  await setCookies();
  console.log("Cookie state restored with:", JSON.stringify(cookies, null, 2));
};
