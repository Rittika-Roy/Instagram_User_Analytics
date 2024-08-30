USE ig_clone;

-- Loyal User Reward = Identifying the five oldest users on Instagram 
SELECT * FROM users
ORDER BY created_at ASC
LIMIT 5;

-- Inactive User Engagement: Identifying users who have never posted a single photo on Instagram.
SELECT id,username FROM users 
WHERE id NOT IN (SELECT DISTINCT(user_id) 
					FROM photos);
                    
 -- Contest Winner Declaration:  Determining user with the most likes on a single photo and provide their details to the team. 
 SELECT p.user_id, u.username ,p.id as photo_id, COUNT(*) as tot_likes
 FROM photos p
 JOIN likes l
 ON p.id = l.photo_id
 JOIN users u
 ON u.id = p.user_id
GROUP BY p.id 
ORDER BY tot_likes DESC
LIMIT 1
;
 
-- Hashtag Research:  Identify and suggest the top five most commonly used hashtags on the platform.
SELECT t1.tag_name, COUNT(*) as times_tag_used FROM 
tags t1 JOIN photo_tags t2 
ON t1.id=t2.tag_id
GROUP BY t1.tag_name
ORDER BY times_tag_used DESC
LIMIT 5;

-- Ad Campaign Launch: Determining the day of the week when most users register on Instagram. 
SELECT DAYNAME(created_at) AS day_of_week, COUNT(*) AS tot_registrations
FROM users
GROUP BY day_of_week
ORDER BY tot_registrations DESC
 LIMIT 1
;


-- User Engagement: Calculating the average number of posts per user on Instagram. 
--                  Also, providing the total number of photos on Instagram divided by the total number of users.

SELECT AVG(tot_post_per_user) AS average_posts_per_user  -- This will give the average number of posts per user
FROM (													-- excluding the users who never posted a photo
    SELECT COUNT(*) AS tot_post_per_user
    FROM photos
    GROUP BY user_id
) AS user_posts;

-- This will give the average number of posts per user including the users who never posted a photo
WITH post_count AS (SELECT u.id as user_id,COUNT(p.id) AS tot_photos_per_user FROM 
					 users u  LEFT JOIN photos p
					ON p.user_id=u.id
					GROUP BY u.id)
SELECT SUM(tot_photos_per_user) AS tot_photos,
COUNT(*) AS tot_users,
SUM(tot_photos_per_user)/COUNT(*) AS avg_post_per_user
FROM post_count;

/* Bots & Fake Accounts: Identify users (potential bots) who have liked every single 
photo on the site, as this is not typically possible for a normal user.*/

SELECT l.user_id , u.username
FROM likes l JOIN users u
ON l.user_id=u.id
GROUP BY l.user_id 
HAVING COUNT(l.photo_id) = (SELECT COUNT(*) FROM photos)
ORDER BY u.username;



 