import logging
import sys
import os
from src.configs.settings import settings


LOG_LEVEL = "DEBUG" if settings.DEBUG else "INFO"
if settings.DEBUG:
    PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../'))
    LOGS_DIR = os.path.join(PROJECT_ROOT, 'logs')
    os.makedirs(LOGS_DIR, exist_ok=True)
    logging.basicConfig(
        level=getattr(logging, LOG_LEVEL),
        format='%(asctime)s [%(name)-20s] [%(filename)s :: %(lineno)d]: %(levelname)s - %(message)s',
        datefmt="%d.%m.%Y %H:%M:%S",
        handlers=[
            logging.StreamHandler(sys.stdout),
            logging.FileHandler(os.path.join(LOGS_DIR, 'debug.log'), mode='a')
        ],
        force=True
    )
    logger = logging.getLogger(__name__)

else:
    logger = logging.getLogger(__name__)
    if not logger.handlers:
        logger.propagate = False
        logger.setLevel(LOG_LEVEL)
        handler = logging.StreamHandler(sys.stdout)
        formatter = logging.Formatter(
            '%(asctime)s [%(name)-12s] %(levelname)-8s %(message)s',
            "%d.%m.%Y %H:%M:%S"
        )
        handler.setFormatter(formatter)
        logger.addHandler(handler)
