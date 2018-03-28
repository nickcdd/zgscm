package com.cqzg168.scm.utils;

import java.awt.AlphaComposite;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.RenderingHints;
import java.awt.geom.AffineTransform;
import java.awt.image.AffineTransformOp;
import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLConnection;

import javax.imageio.ImageIO;

/**
 * 图片工具类
 * 
 * @author Mystery
 * @date 2017年4月1日
 *
 */
public final class ImageUtils {

	/**
	 * 图片缩放
	 * 
	 * @param org
	 *            原图路径
	 * @param ratio
	 *            压缩比例
	 * @return
	 */
	public static boolean resize(String org, double ratio) {
		boolean bol = false; // 是否进行了压缩
		String pictype = "";
		if (!"".equals(org) && org != null) {
			pictype = org.substring(org.lastIndexOf(".") + 1, org.length());
		}
		File o = new File(org);
		BufferedImage bi;
		try {
			bi = ImageIO.read(o);
			if (Utils.isNull(bi)) {
				bol = false;
			} else {
				Image itemp = bi.getScaledInstance((int) (bi.getWidth() * ratio), (int) (bi.getHeight() * ratio), BufferedImage.SCALE_AREA_AVERAGING);
				AffineTransformOp op = new AffineTransformOp(AffineTransform.getScaleInstance(ratio, ratio), null);
				itemp = op.filter(bi, null);
				ImageIO.write((BufferedImage) itemp, pictype, o);
				bol = true;
			}
		} catch (IOException e) {
			bol = false;
			e.printStackTrace();
		}
		return bol;
	}

	public static void resizeWidth(String org, int maxWidth) {
		String pictype = "";
		if (!"".equals(org) && org != null) {
			pictype = org.substring(org.lastIndexOf(".") + 1, org.length());
		}
		File o = new File(org);
		try {
			// if (new FileInputStream(o).available() > 204800) {
			BufferedImage bi;
			try {
				bi = ImageIO.read(o);
				double oldHeight = bi.getHeight();
				double oldWidth = bi.getWidth();
				double temp = oldHeight >= oldWidth ? oldHeight : oldWidth;
				double ratio;
				if (maxWidth > temp) {
					ratio = temp / maxWidth;
				} else {
					ratio = maxWidth / temp;
				}
				Image itemp = bi.getScaledInstance((int) (oldWidth * ratio), (int) (oldHeight * ratio), BufferedImage.SCALE_AREA_AVERAGING);
				AffineTransformOp op = new AffineTransformOp(AffineTransform.getScaleInstance(ratio, ratio), null);
				itemp = op.filter(bi, null);
				ImageIO.write((BufferedImage) itemp, pictype, o);
			} catch (IOException e1) {
				e1.printStackTrace();
			}
			// }
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public static void copyFile(String sourcePath, String targetPath) {
		BufferedInputStream inBuff = null;
		BufferedOutputStream outBuff = null;
		try {
			File sourceFile = new File(sourcePath);
			File targetFile = new File(targetPath);
			if (!targetFile.exists()) {
				targetFile.getParentFile().mkdirs();
			}
			// 新建文件输入流并对它进行缓冲
			inBuff = new BufferedInputStream(new FileInputStream(sourceFile));

			// 新建文件输出流并对它进行缓冲
			outBuff = new BufferedOutputStream(new FileOutputStream(targetFile));

			// 缓冲数组
			byte[] b = new byte[1024 * 5];
			int len;
			while ((len = inBuff.read(b)) != -1) {
				outBuff.write(b, 0, len);
			}
			// 刷新此缓冲的输出流
			outBuff.flush();
		} catch (IOException e) {
			// LogRecord.recode(ImageUtils.class, "图片复制异常:", e.getMessage());
		} finally {
			// 关闭流
			try {
				if (inBuff != null)
					inBuff.close();
				if (outBuff != null)
					outBuff.close();
			} catch (IOException e) {
				// LogRecord.recode(ImageUtils.class, "文件流关闭异常:",
				// e.getMessage());
			}
		}
	}

	/**
	 * 根据经纬度抓取百度地图缩略图
	 * 
	 * @param path
	 * @param lon
	 * @param lat
	 * @return
	 */
	public static String catchImageFromBaidu(String path, Double lon, Double lat, Integer width, Integer height) {
		String center = String.valueOf(lon) + "," + String.valueOf(lat);
		String baiduUrl = "http://api.map.baidu.com/staticimage?width=" + width + "&height=" + height + "&center=" + center + "&zoom=14&markers="
				+ center + "&markerStyles=l,";
		File folder = new File(String.format("%s/BaiduMap/", path));

		try {
			if (!folder.exists()) {
				folder.mkdirs();
			}

			URL url = new URL(baiduUrl);
			URLConnection con = url.openConnection();
			InputStream is = con.getInputStream();
			byte[] bs = new byte[1024];
			int len;
			Long timeStamp = System.currentTimeMillis();
			String fileName = String.format("baiduMap_%s.jpg", String.valueOf(timeStamp));
			OutputStream os = new FileOutputStream(new File(folder, fileName));
			while ((len = is.read(bs)) != -1) {
				os.write(bs, 0, len);
			}
			os.close();
			is.close();

			return String.format("/BaiduMap/%s", fileName);
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}

	/**
	 * 在图片上增加水印
	 * 
	 * @param image
	 */
	public static void addWatermark(File image) {
		OutputStream outputStream = null;
		try {
			Image srcImgObj = ImageIO.read(image);
			BufferedImage bufferedSrcImgObj = new BufferedImage(srcImgObj.getWidth(null), srcImgObj.getHeight(null), BufferedImage.TYPE_INT_RGB);
			// 得到画笔对象
			Graphics2D graphic = bufferedSrcImgObj.createGraphics();
			// 设置对线段的锯齿状边缘处理
			graphic.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
			graphic.drawImage(srcImgObj.getScaledInstance(srcImgObj.getWidth(null), srcImgObj.getHeight(null), Image.SCALE_SMOOTH), 0, 0, null);

			Image icon = ImageIO.read(ImageUtils.class.getResourceAsStream("/watermark.png"));
			/**
			 * 水印图片的大小
			 */
			int iconHeight = icon.getHeight(null);
			int iconWidth = icon.getWidth(null);

			while (bufferedSrcImgObj.getWidth(null) * 0.2 < iconWidth) {
				iconWidth = (int) (iconWidth * 0.8);
				iconHeight = (int) (iconHeight * 0.8);
			}
			while (bufferedSrcImgObj.getHeight(null) * 0.2 < iconHeight) {
				iconWidth = (int) (iconWidth * 0.8);
				iconHeight = (int) (iconHeight * 0.8);
			}

			int xPosition = (srcImgObj.getWidth(null) - iconWidth) / 2;
			int yPosition = (srcImgObj.getHeight(null) - iconHeight) / 2;

			graphic.drawImage(icon, xPosition, yPosition, iconWidth, iconHeight, null);
			graphic.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER));
			graphic.dispose();

			/**
			 * 生成图片
			 */
			outputStream = new FileOutputStream(image);
			ImageIO.write(bufferedSrcImgObj, "JPG", outputStream);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (null != outputStream) {
					outputStream.close();
					outputStream = null;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
}
