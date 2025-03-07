
import hmac, base64, struct, hashlib, time, qrcode, sys, math


DIGITS_POWER = [1,10,100,1000,10000,100000,1000000,10000000,100000000 ]
def get_hotp(secret, intervals):
    key = base64.b32decode(secret, True)
    msg = struct.pack(">Q", intervals)
    hash = hmac.new(key, msg, hashlib.sha1).digest()
    offset = hash[len(hash)-1] & 0xf
    h =((hash[offset] & 0x7f) << 24) |((hash[offset + 1] & 0xff) << 16)|((hash[offset + 2] & 0xff) << 8) |(hash[offset + 3] & 0xff)

    h = h % DIGITS_POWER[6]
    return h
def get_totp(secret):
    res =str(get_hotp(secret,math.floor(int(time.time())/30)))
    while len(res)< 6:
        res+='0'
    return res

secret = 'SECRET'

arg = sys.argv[1]
if arg == "--generate-qr":

    start = 'otpauth://totp/'
    mid = 'Secure%20App%3A%20TOTP:example%40google.com?'
    end = '&issuer=Secure%20App%3A%20TOTP'

    name='example@google.com'
    issuer_name='Secure App:'
    uri = start +mid + 'secret='+ secret + end
    qr = qrcode.QRCode(
            version=1,
            box_size=3,
            border=5)
    qr.add_data(uri)
    qr.make(fit=True)
    code = qr.make_image(fill='black', back_color='white')
    code.save('QRcode.jpg')
    print("File created")

elif arg == "--get-otp":
    initialsleep = 30 - (time.time()%30)
    time.sleep(math.floor(initialsleep))
    time.sleep(2.83)
    while True:
        print(get_totp(secret))
        time.sleep(30)
else:
    print("Invalid argument: ",arg)
    print("Try: --generate-qr or --get-otp ")
