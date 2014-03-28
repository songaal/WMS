package com.websqrd.company.wms.servlet;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.Reader;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.websqrd.company.wms.bean.DAOBean;
import com.websqrd.company.wms.bean.FileInfo;
import com.websqrd.company.wms.dao.FileInfoDAO;

/**
 * Servlet implementation class FileUploadServlet
 */
@WebServlet("/FileUploadServlet")
public class FileDownloadServlet extends HttpServlet {

	protected static Logger logger = LoggerFactory.getLogger(FileDownloadServlet.class);
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public FileDownloadServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doReal(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doReal(request, response);
	}

	protected void doReal(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String fileId = request.getParameter("id");
		if (fileId == null || fileId.isEmpty())
			return;
		FileInfoDAO fileDAO = new FileInfoDAO();
		FileInfo fInfo = fileDAO.select(fileId);

		if (fInfo == null)
			return;

		String storeFileName = fInfo.storeName;
		String prjPath = fInfo.projectId;
		if (prjPath.equals("-1"))
			prjPath = "etc";

		String serverHome = getServletContext().getRealPath("/attachFile");
		String storeFilePath = serverHome + "/" + prjPath + "/" + storeFileName;

		byte[] buffer = new byte[1024];
		
		OutputStream os = response.getOutputStream();
		FileInputStream fis = new FileInputStream(storeFilePath);
		String outFileName = new String(fInfo.fileName.getBytes(),"ISO8859-1");
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Disposition", "attachment;filename=" + outFileName + ";");
		try {
			int readLen = 0;		
			while ((readLen = fis.read(buffer)) != -1) {
				os.write(buffer, 0, readLen);
			}

		} catch (Exception e) {
			logger.error("{}",e);
		} finally {
			os.flush();
			fis.close();
			os.close();
		}

	}

}
