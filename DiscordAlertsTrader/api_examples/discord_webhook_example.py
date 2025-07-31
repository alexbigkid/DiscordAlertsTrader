from discord_webhook import DiscordWebhook

from DiscordAlertsTrader.configurator import cfg


webhook = DiscordWebhook(
    url=cfg["discord"]["webhook"],
    username=cfg["discord"]["webhook_name"],
    content="Test",
    rate_limit_retry=True,
)
webhook.execute()
