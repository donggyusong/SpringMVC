package kr.board.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.board.entity.Board;
import kr.board.mapper.BoardMapper;

@RequestMapping("/board")
@RestController
public class BoardRestController {

	@Autowired
	BoardMapper boardMapper;
	
	@GetMapping("/all")
	public List<Board> boardList(){
		System.out.println("@@@@@@@@@@@@@ 동기");
		List<Board> list = boardMapper.getLists();
		System.out.println("@@@@@@@@@@@@@ 동기2");
		return list; // JSON 데이터 형식으로 변환해서 리턴하겠따.
	}
	
	@PostMapping("/new")
	public  void boardInsert(Board vo) {
		boardMapper.boardInsert(vo); //등록
		
		//@ResponseBody때문에 리턴하는게 없으면 제어권이 요청한 클라이언트쪽으로 간다.
	}
	
	@DeleteMapping("/{idx}")
	public void boardDelete(@PathVariable("idx") int idx) {
		boardMapper.boardDelete(idx); //삭제

	}
	
	@PutMapping("/update")
	public void boardUpdate(@RequestBody Board vo) {
		boardMapper.boardUpdate(vo);
	}
	
	@GetMapping("/{idx}")
	public Board boardContent(@PathVariable("idx") int idx) {
		Board vo =  boardMapper.boardContent(idx);
		return vo; //vo-> JSON으로 바껴서 요청한 클라이언트에게 간다
	}
	
	@PutMapping("/count/{idx}")
	public Board boardCount(@PathVariable("idx") int idx) {
		boardMapper.boardCount(idx);
		Board vo =  boardMapper.boardContent(idx);
		return vo;
	}
	
}
