# Load .env file before any other config or app code
require "lucky_env"
LuckyEnv.load?(".env")

# Require your shards here
require "avram"
require "lucky"
require "lucky_cache"
require "carbon"
require "authentic"
require "jwt"
require "markd"
require "lexbor"
