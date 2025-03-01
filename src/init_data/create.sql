-- CREATE TABLE IF NOT EXISTS users (
--     username VARCHAR(50) PRIMARY KEY,
--     password CHAR(60) NOT NULL,
--     info TEXT
-- );

-- searches made
CREATE TABLE searches (
    search_id SERIAL PRIMARY KEY,
    industry TEXT,
    location TEXT,
    company_size TEXT,
    searched_at TIMESTAMP DEFAULT NOW()
);

-- list of companies found 
CREATE TABLE companies (
    company_id SERIAL PRIMARY KEY,
    name TEXT,
    email TEXT UNIQUE,
    website TEXT,
    industry TEXT,
    location TEXT,
    company_size TEXT,
    added_at TIMESTAMP DEFAULT NOW()
);

-- connnect the company id with the search id it was found with!
CREATE TABLE search_results (
    search_result_id SERIAL PRIMARY KEY,
    search_id INT REFERENCES searches(search_id) ON DELETE CASCADE,
    company_id INT REFERENCES companies(company_id) ON DELETE CASCADE,
    added_at TIMESTAMP DEFAULT NOW()
);

-- ai agents (this is constantly updating, storing how the ai agent does in this moment)
CREATE TABLE ai_agents (
    agent_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    personality TEXT, 
    emails_sent INT DEFAULT 0,
    open_rate FLOAT DEFAULT 0, -- percentage of emails opened
    response_rate FLOAT DEFAULT 0, -- percentage of emails responded to
    last_active TIMESTAMP DEFAULT NOW()  -- Last time the agent sent an email
);

-- ai agent analytics that stores weekly perfomance of the ai agent (will eventually displayed on a history page)
CREATE TABLE agent_analytics (
    agent_stat_id SERIAL PRIMARY KEY,
    agent_id INT REFERENCES ai_agents(agent_id) ON DELETE CASCADE,
    emails_sent INT,
    open_rate FLOAT,
    response_rate FLOAT,
    recorded_at TIMESTAMP DEFAULT NOW() -- Time when stats were logged
);

-- emails
CREATE TABLE emails (
    email_id SERIAL PRIMARY KEY,
    company_id INT REFERENCES companies(company_id) ON DELETE CASCADE,
    sent_by INT REFERENCES ai_agents(agent_id) ON DELETE SET NULL,
    subject TEXT NOT NULL,
    body TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT NOW(),
    status VARCHAR(20) CHECK (status IN ('sent', 'opened', 'responded', 'bounced'))
);

-- analytics per industry are stored in here
CREATE TABLE industry_analytics (
    industry_stat_id SERIAL PRIMARY KEY,
    industry TEXT NOT NULL,
    total_emails_sent INT DEFAULT 0,
    open_rate FLOAT DEFAULT 0, 
    response_rate FLOAT DEFAULT 0, 
    total_companies_contacted INT DEFAULT 0,
    last_updated TIMESTAMP DEFAULT NOW()
);
