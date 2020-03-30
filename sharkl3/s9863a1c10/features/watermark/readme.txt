9:51 2019/10/15
logo watermark:
    * add logo to the picture when capture.
    * logo source file should be *.rgba, you can try to convert *.png to *.rgba
    * you can prepare logo source file for every size of capture.
    * logo source width,height should align to 2
    * If you want to change name and size, please modify these code cmr_oem.c
      function:camera_select_logo,camera_get_logo_data

time watermark:
    * add timestamp to the picture when capture
    * logo source file should be time.yuv, include "0123456789-: "(last one is space) in the yuv file.
      you can create time.png by pc-software as GIMP, include the elements for timestamp.
    * Every elements should have the same width and height, and should align to 2
    * If you want to change, please modify these cod cmr_oem.c,function:camera_get_time_yuv420

1: libcamera��code�ɵ�������,
   1) adb root;adb remount;adb shell
      cd /vendor/
      mkdir logo
      chown system:system logo
      Ȼ����Ӧ���ļ�push����logoĿ¼��
   2) ��δ�޸�code,�밴watermarkĿ¼�µ��ļ���,����С
      ׼��rgba�ļ�,������������վ��png�ļ�ת��rgba
      https://convertio.co/zh/rgba-converter/
   3) adb root;adb remount;adb shell
      setprop debug.vendor.cam.watermark.test 1
   4) �л�����size(������code��ʾsize��Ӧ),������
      �����Ļ��Ϳ��Կ�����Ƭ����ˮӡ.
   5) �˳���������,��setprop debug.vendor.cam.watermark.test 0

//logoͼƬ(*.rgba)
	��������ʹ�ø�size��ص��ļ�����, ����Ҫ�޸�,���ں���camera_select_logo,
	camera_get_logo_data, device��mk��ͬ���޸�
	����:
	    Դͼ�����png, ��Ϊpng��͸����Ϣ. jpeg,bmp�Ȳ���͸����Ϣ.
            ���޸�size, �뾡����˿������2����(����uv���ݲ��ܶ���,����ʱ��׼).
            �����޸�size, logo���ܱ�Ե������հ�.

//ʱ���ͼƬ(yuv)
	ͼƬ���ݰ�ʱ�����Ҫ��Ҫ��, ����������, �ȿ��ַ�,����������2����.
	ͼƬ��ȡ��Ҫ�ں���camera_get_time_yuv420,��Щ��Ϣ��Ҫ��ͼ���Ӧ:�ļ���, �ַ���(13��),�ַ����.
	13���ַ�˳��(0123456789-: )���һ��Ϊ�ո�.
        ����: ��ʹ��ͼƬ�������(ps),������png, ��ת��yuv.���������ɺ��,��(312(=24*13)*48,��ƺú�, ������ͼ˳ʱ��ת90��,�ٵ�����png.
	���2����,uv���ݲ��ܶ���, ����,uv���ݿ��ܶԲ���,��������Ч������ɫ��ƫ��.

cmr_oem.c
logo watermark:info:
cmr_int camera_select_logo(sizeParam_t *size) {
    cmr_int ret = -1;
    cmr_uint i;
    const sizeParam_t cap_logo[] = {
        /* cap: width,height;logo:width,height;cap:posx,posy */
        {4000, 3000, 1200, 240, 0, 0, 0, 0},
        {4000, 2250, 1200, 240, 0, 0, 0, 0},
        {2592, 1944, 1000, 200, 0, 0, 0, 0},
        {2592, 1458, 1000, 200, 0, 0, 0, 0},
        {2048, 1536, 800, 160, 0, 0, 0, 0},
        {2048, 1152, 800, 160, 0, 0, 0, 0},
    };
time watermark:info,
cmr_int camera_get_time_yuv420(cmr_u8 **data, int *width, int *height) {
    cmr_s32 rtn = -1;
    char tmp_name[128];
    /* info of source file for number */
    const char file_name[] = "time.yuv"; /* source file for number:0123456789-:  */
    const int subnum_total = 13;  /* 0--9,-,:, (space), all= 13 */
    const int subnum_width = 80;  /* sub number width:align 2 */
    const int subnum_height = 40; /* sub number height:align 2 */
