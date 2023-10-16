SET GLOBAL sql_mode = 'ONLY_FULL_GROUP_BY';
/*1. Are the goals for dollars raised significantly 
different between campaigns that are successful and 
unsuccessful?*/
select camp.outcome, avg(camp.goal) as 'Total Goal'
from (select * from campaign where outcome in ('successful','failed')) as camp
group by camp.outcome;
/*2. What are the top/bottom 3 categories with the most 
backers? What are the top/bottom 3 subcategories by backers?*/
(select category.name as 'Category', sum(backers) as 'Backers'
from campaign join sub_category
on campaign.sub_category_id = sub_category.id
join category on sub_category.category_id = category.id
group by category.name
order by sum(backers) desc limit 3)
UNION
(select category.name as 'Category', sum(backers) as 'Backers'
from campaign join sub_category
on campaign.sub_category_id = sub_category.id
join category on sub_category.category_id = category.id
group by category.name
having sum(backers) != 0
order by sum(backers) limit 3);
(select sub_category.name as 'SubCategory', sum(backers) as 'Backers'
from campaign join sub_category 
on campaign.sub_category_id = sub_category.id
group by sub_category.name
having sum(backers)
order by sum(backers) desc limit 3)
UNION
(select sub_category.name as 'SubCategory', sum(backers) as 'Backers'
from campaign join sub_category 
on campaign.sub_category_id = sub_category.id
group by sub_category.name
having sum(backers) != 0
order by sum(backers) limit 3);
/*3. What are the top/bottom 3 categories that have raised
the most money? What are the top/bottom 3 subcategories that
have raised the most money?*/
(select category.name as 'Category', sum(pledged) as 'Pledged'
from campaign join sub_category
on campaign.sub_category_id = sub_category.id
join category on sub_category.category_id = category.id
group by category.name
order by sum(pledged) desc limit 3)
UNION
(select category.name as 'Category', sum(pledged) as 'Pledged'
from campaign join sub_category
on campaign.sub_category_id = sub_category.id
join category on sub_category.category_id = category.id
group by category.name
having sum(pledged) != 0
order by sum(pledged) limit 3);
(select sub_category.name as 'SubCategory', sum(pledged) as 'Pledged'
from campaign join sub_category 
on campaign.sub_category_id = sub_category.id
group by sub_category.name
having sum(pledged)
order by sum(pledged) desc limit 3)
UNION
(select sub_category.name as 'SubCategory', sum(pledged) as 'Pledged'
from campaign join sub_category 
on campaign.sub_category_id = sub_category.id
group by sub_category.name
having sum(pledged) != 0
order by sum(pledged) limit 3);
/*4. What was the amount the most successful board game company
raised? How many backers did they have?*/
select name, sum(pledged) as 'TotalPledged', sum(backers) as 'TotalBackers'
from campaign
where name like '%board game%'
group by name
order by sum(pledged) desc limit 1;
/*5. Rank the top three countries with the most successful 
campaigns in terms of dollars (total amount pledged), and
in terms of the number of campaigns backed.*/
select country.name, sum(pledged), sum(backers)
from campaign join country
on campaign.country_id = country.id
group by country.name
having sum(pledged) != 0
order by sum(pledged) desc limit 3;
/*6. Do longer, or shorter campaigns tend to raise more money?
Why?*/
select datediff(deadline,launched) as 'CampaignTime', avg(pledged) as 'AverageCampaignGoal'
from campaign
group by CampaignTime
order by CampaignTime;