# Twocaptcha

The unmoral webservice's api client library and command line interface

## Status

- [X] Uploading CAPTCHA
- [X] Getting the solved CAPTCHA
- [ ] Getting the status of several CAPTCHAs
- [ ] Complain about the wrong CAPTCHA
- [ ] Get account balance
- [ ] Get account statistics
- [ ] Get how many decoders are waiting for CAPTCHA

## Library usage

`(TBD)`

## CLI usage

```
qlot install
qlot exec ./twocaptcha.ros --help
```

```
qlot exec ./twocaptcha.ros --apikey=your_api_key --queries="numeric=1 min_len=4 max_len=4 phrase=0" base64_encoded_image
```

## Installation

```
ros build ./twocaptcha.ros
```

## Test

```
qlot install
qlot exec run-prove ./twocaptcha-test.asd
```

## Author

supermomonga

## Copyright

Copyright (c) 2016 supermomonga

## License

Licensed under the MIT License.
