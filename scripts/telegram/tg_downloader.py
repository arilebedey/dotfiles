import asyncio
import os
import sys

from pyrogram import Client

API_ID = 17349
API_HASH = "344583e45741c457fe1862106095a5eb"
BOT_TOKEN = "your_bot_token_here"
DOWNLOAD_DIR = "/home/alebedev/Downloads"


async def main():
    if len(sys.argv) < 2:
        print("Usage: python tg_downloader.py <telegram_link>")
        return

    link = sys.argv[1]

    parts = link.strip().split("/")
    message_id = int(parts[-1])

    if "/c/" in link:
        chat_id = int("-100" + parts[-2])
    else:
        chat_id = parts[-2]

    async with Client("bot", API_ID, API_HASH, bot_token=BOT_TOKEN) as app:
        print(f"Fetching message {message_id} from {chat_id}...")
        msg = await app.get_messages(chat_id, message_id)

        if msg.video or msg.document:
            media = msg.video or msg.document
            file_name = getattr(media, "file_name", None)
            if not file_name:
                file_name = f"video_{message_id}.mp4"

            print(f"Downloading: {file_name}")

            path = await app.download_media(
                msg, file_name=os.path.join(DOWNLOAD_DIR, file_name)
            )
            print(f"Successfully saved to: {path}")
        else:
            print("Error: No video found in that message.")


if __name__ == "__main__":
    asyncio.run(main())
