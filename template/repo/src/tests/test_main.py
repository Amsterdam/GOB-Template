from unittest import TestCase
from unittest.mock import patch


class TestMain(TestCase):

    @patch("builtins.print")
    def test_main_entry(self, mock_print):
        from GOB_TEMPLATE_PYTHON_MODULE_NAME import __main__ as module
        with patch.object(module, "__name__", "__main__"):
            module.init()
            mock_print.assert_called_with('Hello. Welcome to your new GOB service. Go wild!')
