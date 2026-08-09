/// CoreSaveFileIO.gml

function core_save_write_file(
    _filename
)
{
    if (
        !is_string(_filename) ||
        string_length(_filename) <= 0
    )
    {
        return false;
    }

    var _save_data =
        core_save_build_data();

    if (is_undefined(_save_data))
    {
        return false;
    }

    var _json_text = "";

    try
    {
        _json_text =
            json_stringify(
                _save_data
            );
    }
    catch (_exception)
    {
        return false;
    }

    if (string_length(_json_text) <= 0)
    {
        return false;
    }

    var _file =
        file_text_open_write(
            _filename
        );

    if (_file < 0)
    {
        return false;
    }

    file_text_write_string(
        _file,
        _json_text
    );

    file_text_close(_file);

    return file_exists(
        _filename
    );
}


function core_save_read_file(
    _filename
)
{
    if (
        !is_string(_filename) ||
        string_length(_filename) <= 0 ||
        !file_exists(_filename)
    )
    {
        return undefined;
    }

    var _file =
        file_text_open_read(
            _filename
        );

    if (_file < 0)
    {
        return undefined;
    }

    var _json_text =
        file_text_read_string(
            _file
        );

    file_text_close(_file);

    if (string_length(_json_text) <= 0)
    {
        return undefined;
    }

    var _save_data = undefined;

    try
    {
        _save_data =
            json_parse(
                _json_text
            );
    }
    catch (_exception)
    {
        return undefined;
    }

    if (!is_struct(_save_data))
    {
        return undefined;
    }

    return _save_data;
}