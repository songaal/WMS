package co.fastcat.wms.servlet;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
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

import co.fastcat.wms.bean.FileInfo;
import co.fastcat.wms.dao.FileInfoDAO;

/**
 * Servlet implementation class FileUploadServlet
 */
@WebServlet("/FileUploadServlet")
public class FileUploadServlet extends HttpServlet {

	protected static Logger logger = LoggerFactory.getLogger(FileUploadServlet.class);
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public FileUploadServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().print("OK");
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
		request.setCharacterEncoding("UTF-8");
		PrintWriter pw = response.getWriter();
		response.setContentType("text/html");

		String userId = "";
		String projectId = "";
		String desc = "";
		String uploadFileName = "";
		String uploadFilePath = "";
		String storeFileName = "";

		InputStream in = null;

		FileItemFactory factory = new DiskFileItemFactory();
		ServletFileUpload upload = new ServletFileUpload(factory);
		List<FileItem> items = null;
		try {
			items = upload.parseRequest(request);

			for (FileItem fitem : items) {
				if (!fitem.isFormField()) {
					logger.debug("file : {}", fitem);
					storeFileName = System.currentTimeMillis() + "";
					in = fitem.getInputStream();
					uploadFileName = fitem.getName().substring(fitem.getName().lastIndexOf("\\") + 1);
				} else {
					if (fitem.getFieldName().equals("userid"))
						userId = fitem.getString().trim();
					else if (fitem.getFieldName().equals("projectSelect"))
						projectId = fitem.getString().trim();
					else if (fitem.getFieldName().equals("desc"))
						desc = new String(fitem.getString().trim().getBytes("ISO-8859-1"), "UTF-8");
				}
			}
		} catch (FileUploadException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		logger.debug("userId : {}", userId);
		logger.debug("projectId : {}", projectId);
		logger.debug("desc : {}", desc);
		logger.debug("fileName : {}", uploadFileName);

		if (in == null) {
			logger.debug("input stream is null ");
			pw.println("{\"result\":1, \"errmsg\":\"cannot read file\"}");
			return;
		}

		try {
			String prjPath = "";

			if (projectId.equals("-1"))
				prjPath = "etc";
			else
				prjPath = projectId;

			String serverHome = getServletContext().getRealPath("/attachFile");
			String storeFilePath = serverHome + "/" + prjPath + "/" + storeFileName;
			String storeProjectDir = serverHome + "/" + prjPath;

			logger.debug("store File Dir : {}", storeProjectDir);
			logger.debug("store File Path : {}", storeFilePath);

			File attachDir = new File(serverHome);
			if (attachDir.exists() == false)
				attachDir.mkdir();

			File dir = new File(storeProjectDir);
			dir.mkdir();
			File storeFile = new File(storeFilePath);

			if (!storeFile.exists())
				storeFile.createNewFile();

			FileOutputStream fos = new FileOutputStream(storeFile);
			byte[] buffer = new byte[1024];
			int readLen = 0;
			try {
				while ( (readLen = in.read(buffer)) != -1) {					
					fos.write(buffer, 0, readLen);					
				}
			}
			finally {
				fos.flush();
				fos.close();
				in.close();
			}

			FileInfoDAO fDAO = new FileInfoDAO();
			FileInfo fInfo = new FileInfo();
			fInfo.fileName = uploadFileName;
			fInfo.storeName = storeFileName;
			fInfo.projectId = projectId;
			fInfo.userSid = userId;
			fInfo.desc = desc;
			fDAO.create(fInfo);

			logger.debug("4444");

			pw.println("{\"result\":0\"}");
		} catch (Exception e) {
			pw.println("{\"result\":1, \"errmsg\":\" " + e.getMessage() + " \"}");
			return;
		}

	}

	public void init() {
		String serverHome = getServletContext().getRealPath("/attach");
	}
}
