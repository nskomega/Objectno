import base64
import io
import unittest
from PIL import Image
from worker import decode_photo

class PhotoTest(unittest.TestCase):
    def test_mpo_uses_the_primary_jpeg_not_the_auxiliary_frame(self):
        output=io.BytesIO()
        primary=Image.new('RGB',(40,20),'red')
        primary.save(output,format='MPO',save_all=True,append_images=[Image.new('RGB',(40,20),'blue')])
        decoded=decode_photo(base64.b64encode(output.getvalue()).decode())
        self.assertEqual(decoded.size,(40,20))
        red,_,blue=decoded.getpixel((10,10))
        self.assertGreater(red,200)
        self.assertLess(blue,30)

    def test_exif_orientation_is_applied_and_metadata_removed(self):
        output=io.BytesIO()
        image=Image.new('RGB',(40,20),'white')
        exif=Image.Exif();exif[274]=6;exif[270]='Private fixture metadata'
        image.save(output,format='JPEG',exif=exif)
        decoded=decode_photo(base64.b64encode(output.getvalue()).decode())
        self.assertEqual(decoded.size,(20,40))
        self.assertFalse(decoded.info)
        self.assertFalse(decoded.getexif())

    def test_other_formats_and_corrupt_bytes_are_rejected(self):
        output=io.BytesIO();Image.new('RGB',(4,4)).save(output,format='GIF')
        for raw in [output.getvalue(),b'not a photo']:
            with self.assertRaises(ValueError):decode_photo(base64.b64encode(raw).decode())

if __name__=='__main__':unittest.main()
